local M = {}

local type_list = require("p.type_table")

---@return string
local function which()
    return vim.bo.filetype
end

---@param marker string
---@return boolean
local function is_prj(marker)
    if vim.fs.root(0, marker) then return true else return false end
end

---@param opts table
---@param commands table
local function picker(opts, commands)
    if not commands or not (#commands > 0) then return print("There's nothing to do.") end
    opts = opts or {}
    local pickers = require("telescope.pickers")
    local finder = require("telescope.finders")
    local conf = require("telescope.config").values

    pickers.new(
        opts,
        {
            prompt_title = "Options",
            finder = finder.new_table {
                results = commands,
                entry_maker = function(entry)
                    return {
                        value = entry.cmd,
                        display = entry.label,
                        ordinal = entry.label,
                    }
                end
            },
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    if not selection then return end
                    actions.close(prompt_bufnr)
                    if type(selection.value) == "function" then
                        selection.value()
                    else
                        vim.api.nvim_cmd(
                            vim.api.nvim_parse_cmd(":hor te " .. selection.value, {}),
                            {}
                        )
                    end
                end)
                return true
            end,
        }):find()
end

---@param tbl table
---@param prefix? string
---@return table
local function mk_choice(tbl, prefix)
    if not tbl or type(tbl) ~= "table" then return {} end
    prefix = prefix or ""

    local result = {}

    if #tbl > 0 then
        for _, v in ipairs(tbl) do
            local sub = mk_choice(v, prefix)
            for _, s in ipairs(sub) do
                table.insert(result, s)
            end
        end
        return result
    end

    local current = prefix ~= "" and (prefix .. " -> " .. tbl.name) or tbl.name

    if type(tbl.cmd) == "string" then
        local label = current .. ": " .. tbl.cmd
        if tbl.desc then label = label .. " -- " .. tbl.desc end
        table.insert(result, { label = label, cmd = tbl.cmd })
    elseif type(tbl.cmd) == "function" then
        local label = current .. ": lua function"
        if tbl.desc then label = label .. " -- " .. tbl.desc end
        table.insert(result, { label = label, cmd = tbl.cmd })
    elseif type(tbl.cmd) == "table" and #tbl.cmd > 0 then
        local sub = mk_choice(tbl.cmd, current)
        for _, s in ipairs(sub) do
            table.insert(result, s)
        end
    end

    return result
end

function M.something()
    ---@type table
    local cmd_list
    for _, t in ipairs(type_list) do
        if which() == t.type or is_prj(t.project.marker) then
            cmd_list = mk_choice(t.commands)
            if is_prj(t.project.marker) then
                for _, v in ipairs(mk_choice(t.project.commands)) do
                    table.insert(cmd_list, v)
                end
            end
        end
    end
    return picker({}, cmd_list)
end

return M

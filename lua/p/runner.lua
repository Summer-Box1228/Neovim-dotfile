local M = {}

local type_list = setmetatable(require("p.type_table"), {
    __add = function(type_list, i)
        if type(i) ~= "table" then return error("item in type list must be a table") end
        return table.insert(type_list, i)
    end
})

local function which()
    return vim.bo.filetype
end
local function is_prj(marker)
    if vim.fs.root(0, marker) then return true else return false end
end

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
                    vim.api.nvim_cmd(
                        vim.api.nvim_parse_cmd(":hor te " .. selection.value, {}),
                        {}
                    )
                end)
                return true
            end,
        }):find()
end
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
        table.insert(result, { label = current .. ": " .. tbl.cmd, cmd = tbl.cmd })
    elseif type(tbl.cmd) == "table" and #tbl.cmd > 0 then
        local sub = mk_choice(tbl.cmd, current)
        for _, s in ipairs(sub) do
            table.insert(result, s)
        end
    end

    return result
end

function M.something()
    local cmd_list
    for _, t in ipairs(type_list) do
        if which() == t.type or (which() == "netrw" and is_prj(t.project.marker)) then
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

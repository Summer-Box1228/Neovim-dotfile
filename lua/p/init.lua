local M = {}
function M.setup()
    vim.api.nvim_create_user_command(
        "DoSome",
        function(opts)
            require("p").do_something()
        end,
        {}
    )
    vim.api.nvim_create_autocmd(
        "BufEnter",
        {
            pattern = "*",
            callback = function()
                local file = vim.fn.expandcmd("%:p:h")
                if file then
                    vim.cmd.cd(file)
                end
            end,
        }
    )
end

function M.do_something()
    return require("p.runner").something()
end

return M

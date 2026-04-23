vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "<leader>tt", vim.cmd.te)
vim.keymap.set("n", "<leader>sh",
    function()
        vim.ui.input({ prompt = '$ ' },
            function(cmd)
                if cmd then
                    vim.cmd('!' .. cmd)
                end
            end
        )
    end
)

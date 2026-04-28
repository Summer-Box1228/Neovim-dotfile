return {
    {
        type = "c",
        compiler = "cc",
        project = {
            marker = {
                "Makefile",
                "CMakeList.txt",
            },
            commands = {
                {
                    name = "make",
                    cmd = {
                        {
                            name = "build",
                            cmd = "make",
                        },
                        {
                            name = "install",
                            cmd = "make install",
                        },
                    },
                },
                {
                    name = "cmake",
                    cmd = "cmake .",
                },
            },
        },
        commands = {
            name = "default",
            cmd = {},
        },
    },
    {
        type = "rust",
        compiler = "rustc",
        project = {
            marker = {
                "Cargo.toml",
            },
            commands = {
                name = "cargo",
                cmd = {
                    {
                        name = "build",
                        cmd = "cargo b",
                    },
                    {
                        name = "run",
                        cmd = "cargo r",
                    },
                    {
                        name = "echo hello",
                        cmd = function()
                            vim.api.nvim_cmd(
                                vim.api.nvim_parse_cmd(":!echo hello", {}),
                                {}
                            )
                        end,
                        desc = "hello",
                    },
                },
            },
        },
        commands = {
            name = "default",
            cmd = "echo \'hello world\'",
        },
    },
}

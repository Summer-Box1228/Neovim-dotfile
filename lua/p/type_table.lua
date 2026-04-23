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
                },
            },
        },
        commands = {
            name = "default",
            cmd = "echo \'hello world\'",
        },
    },
}

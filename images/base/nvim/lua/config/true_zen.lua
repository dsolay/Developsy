local true_zen = require('true-zen')

true_zen.setup(
    {
        integrations = {
            tmux = true,
            gitsigns = true,
            twilight = true,
        },
        misc = {
            on_off_commands = true,
            ui_elements_commands = true,
            cursor_by_mode = true,
        },
    }
)

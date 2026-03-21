local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.adapters.php = {
  type = "executable",
  command = "node",
  args = { "/home/szilvassy-bence/.local/share/nvim/php-debug-adapter/out/phpDebug.js" },
}
dap.configurations.php = {
  {
    type = "php",
    request = "launch",
    name = "Listen for Xdebug locally",
    idekey = "VSCODE",
    port = 9003,
    -- pathMappings = {
    --   ["/var/www"] = "${workspaceFolder}", -- adjust as needed
    -- },
  },
  {
    type = "php",
    request = "launch",
    name = "Listen for Xdebug in Docker",
    idekey = "VSCODE",
    port = 9003,
    pathMappings = {
      ["/var/www"] = "${workspaceFolder}", -- adjust as needed
    },
  },
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set('n', '<F5>', function() require'dap'.continue() end)
vim.keymap.set('n', '<F10>', function() require'dap'.step_over() end)
vim.keymap.set('n', '<F11>', function() require'dap'.step_into() end)
vim.keymap.set('n', '<F12>', function() require'dap'.step_out() end)
vim.keymap.set('n', '<Leader>br', function() require'dap'.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>du', function() require'dapui'.toggle() end)

vim.keymap.set('n', '<Leader>bc', function()
  local dap = require('dap')
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
    if input then
      dap.set_breakpoint(nil, nil, input)
    end
  end)
end)

vim.keymap.set('n', '<Leader>dt', function() require'dap'.terminate() end, { desc = "Dap Terminate" })

vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)

vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)

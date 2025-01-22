local M = {}

function M.setup(opts)
    M.width = not opts.width and 80 or opts.width
    M.height = not opts.height and 20 or opts.height

    vim.api.nvim_set_keymap('n', '<leader>tf', '', {
        noremap = true,
        silent = true,
        callback = M.toggle_fterm
    })
    vim.api.nvim_set_keymap('t', '<leader>tf', '', {
        noremap = true,
        silent = true,
        callback = M.toggle_fterm
    })
end

function M.open_fterm()
    local bufnr = M.bufnr

    if not bufnr or not vim.api.nvim_buf_is_valid(M.bufnr) then
        bufnr = vim.api.nvim_create_buf(false, true);
    end

    local opts = {
        relative = "editor",
        width = M.width,
        height = M.height,
        col = (vim.o.columns - M.width) / 2,
        row = (vim.o.lines - M.height) / 2,
        style = "minimal",
        border = "rounded",
    }

    M.win = vim.api.nvim_open_win(bufnr, true, opts)

    if not M.termbufnr or not vim.api.nvim_buf_is_valid(M.bufnr) then
        M.termbufnr = vim.fn.termopen(os.getenv("SHELL"))
    end

    M.bufnr = bufnr

    vim.cmd("startinsert")
end

function M.toggle_fterm()
    if M.win and vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_hide(M.win)
    else
        M.open_fterm()
    end
end

return M

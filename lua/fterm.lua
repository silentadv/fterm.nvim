local M = {}

function M.setup(opts)
    M.width = (opts and opts.width) or 80
    M.height = (opts and opts.height) or 20

    vim.keymap.set({ "n", "t" }, '<leader>tf', M.toggle_fterm, {
        noremap = true,
        silent = true,
        desc = "Toggle floating terminal"
    })
end

function M.open_fterm()
    if not M.termbufnr or not vim.api.nvim_buf_is_valid(M.termbufnr) then
        M.termbufnr = vim.api.nvim_create_buf(false, true)
        vim.fn.termopen(os.getenv("SHELL"), { buffer = M.termbufnr })
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

    M.win = vim.api.nvim_open_win(M.termbufnr, true, opts)

    vim.cmd("startinsert")
end

function M.toggle_fterm()
    if M.win and vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_hide(M.win)
        M.win = nil
    else
        M.open_fterm()
    end
end

return M


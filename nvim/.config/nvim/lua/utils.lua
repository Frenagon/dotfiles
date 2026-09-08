M = {}

M.map = function(mode, keys, action, desc)
	desc = desc or ""
	local opts = { noremap = true, silent = true, desc = desc }
	vim.keymap.set(mode, keys, action, opts)
end

M.is_repo_modified = function()
	local handle = io.popen("git status --porcelain 2> /dev/null")
	local result
	if handle then
		result = handle:read("*a")
		handle:close()
	end

	return (result and #result > 0)
end

return M

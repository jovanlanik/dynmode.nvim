local pkg_name = 'dynmode'
local M = {}

M.opt = {}

local function default_callback(mode)
	if(string.byte(mode) == 22) then
		mode = 'v' -- 22 equals ^V
	end
	if(string.byte(mode) == 13) then
		mode = 's' -- 13 equals ^S
	end
	return M.opt.list[mode] or M.opt.default
end

local default = {
	mode_callback = default_callback;
	hl_default = { link = 'Normal' };
	hl_targets = { 'ModeMsg', 'CursorLineNr' };
	hl_list = {
		['v'] = { link = 'PreProc' };
		['V'] = { link = 'PreProc' };
		['i'] = { link = 'Type' };
		['R'] = { link = 'Statement' };
	};
}

local function set_modemsg()
	local mode = vim.api.nvim_get_mode().mode
	local hl = M.opt.mode_callback(mode)
	for _, target in ipairs(M.opt.hl_targets) do
		vim.api.nvim_set_hl(0, target, hl)
	end
end

M.setup = function(opts)
	M.opt = vim.tbl_extend('force', default, opts or {})

	local au_opts = { group = pkg_name, callback = set_modemsg }
	vim.api.nvim_create_augroup(pkg_name, {})
	vim.api.nvim_create_autocmd('ModeChanged', au_opts)
end

return M

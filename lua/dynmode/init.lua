local M = {}
local options = {}

local function hlfn(mode)
	if(string.byte(mode) == 22) then
		mode = 'v' -- 22 equals ^V
	end
	if(string.byte(mode) == 13) then
		mode = 's' -- 13 equals ^S
	end
	return options.list[mode] or options.default
end

local default = {
	callback = hlfn;
	default = { link = 'Normal' };
	targets = { 'ModeMsg', 'CursorLineNr' };
	list = {
		['v'] = { link = 'PreProc' };
		['V'] = { link = 'PreProc' };
		['i'] = { link = 'Type' };
		['R'] = { link = 'Statement' };
	};
}

local function set_modemsg()
	local mode = vim.api.nvim_get_mode().mode
	local hl = options.callback(mode)
	for _, target in ipairs(options.targets) do
		vim.api.nvim_set_hl(0, target, hl)
	end
end

M.setup = function(opts)
	options = vim.tbl_extend('force', default, opts or {})
	vim.api.nvim_create_augroup('dynmode', {})
	vim.api.nvim_create_autocmd('ModeChanged', { group = 'dynmode', callback = set_modemsg })
end

return M

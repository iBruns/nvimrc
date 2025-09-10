return {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		filewatching = "auto",
		choose_target = nil,
		ignore_target = nil,
		broad_search = false,
		lock_target = false,
		silent = false,
	},
}

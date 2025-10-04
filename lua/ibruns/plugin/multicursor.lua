return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

		-- ── Add/Skip cursors vertically ────────────────────────────────
		set({ "n", "x" }, "<up>", function()
			mc.lineAddCursor(-1)
		end, { desc = "Add cursor above" })
		set({ "n", "x" }, "<down>", function()
			mc.lineAddCursor(1)
		end, { desc = "Add cursor below" })

		set({ "n", "x" }, "<leader><up>", function()
			mc.lineSkipCursor(-1)
		end, { desc = "Skip line above" })
		set({ "n", "x" }, "<leader><down>", function()
			mc.lineSkipCursor(1)
		end, { desc = "Skip line below" })

		-- ── Add/Skip cursors by word or selection ─────────────────────
		set({ "n", "x" }, "<leader>mn", function()
			mc.matchAddCursor(1)
		end, { desc = "Add next match cursor" })
		set({ "n", "x" }, "<leader>ms", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip next match" })

		set({ "n", "x" }, "<leader>MN", function()
			mc.matchAddCursor(-1)
		end, { desc = "Add prev match cursor" })
		set({ "n", "x" }, "<leader>MS", function()
			mc.matchSkipCursor(-1)
		end, { desc = "Skip prev match" })

		-- ── Mouse interaction ─────────────────────────────────────────
		set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Ctrl+Click: toggle cursor" })
		set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Ctrl+Drag: add cursors" })
		set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Ctrl+Release: finalize cursors" })

		-- ── Toggle cursors ────────────────────────────────────────────
		set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle multicursor mode" })

		-- ── Extra mappings (active only with multiple cursors) ────────
		mc.addKeymapLayer(function(layerSet)
			layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Select previous cursor" })
			layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Select next cursor" })

			layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor, { desc = "Delete main cursor" })

			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end, { desc = "Enable/clear cursors" })
		end)

		-- ── Highlight groups ──────────────────────────────────────────
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}

local wezterm = require("wezterm")

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local function get_dir(tab)
	local cwd = tab.active_pane.current_working_dir.file_path
	local home = os.getenv("HOME")

	cwd = cwd:gsub(string.format("%%%s", home), "~")

	return string.format(" %s", cwd)
end

local function get_process(tab)
	local process = tab.active_pane.foreground_process_name
	return process:gsub("(.*/)(.*)", "%2")
end

local function active_tab_index(mux_win)
	for _, item in ipairs(mux_win:tabs_with_info()) do
		if item.is_active then
			return item.index
		end
	end
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#48394f"
		foreground = "#66a8de"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = string.format("%d.%s:%s", tab.tab_index + 1, get_dir(tab), get_process(tab)) },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

return {
	color_scheme = "VSCodeDark+ (Gogh)",
	force_reverse_video_cursor = true,
	tab_bar_at_bottom = true,
	default_cursor_style = "BlinkingBlock",
	font = wezterm.font_with_fallback({
		"Monaspace Neon",
		"JetBrains Mono",
	}),
	exit_behavior = "Close",
	window_close_confirmation = "NeverPrompt",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	window_frame = {
		font = wezterm.font({ family = "Hack", weight = "Bold" }),
		font_size = 10,
	},
	font_size = 11,
	audible_bell = "Disabled",
	keys = {
		{
			key = "t",
			mods = "ALT",
			action = wezterm.action_callback(function(win, pane)
				local mux_win = win:mux_window()
				local idx = active_tab_index(mux_win)
				-- wezterm.log_info('active_tab_idx: ', idx)
				local tab = mux_win:spawn_tab({})
				-- wezterm.log_info('movetab: ', idx)
				win:perform_action(wezterm.action.MoveTab(idx + 1), pane)
			end),
		},
		{
			key = "t",
			mods = "ALT|SHIFT",
			action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
		},
		{
			key = "s",
			mods = "ALT",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "s",
			mods = "ALT|SHIFT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "h",
			mods = "ALT",
			action = wezterm.action({ ActivatePaneDirection = "Left" }),
		},
		{
			key = "l",
			mods = "ALT",
			action = wezterm.action({ ActivatePaneDirection = "Right" }),
		},
		{
			key = "k",
			mods = "ALT",
			action = wezterm.action({ ActivatePaneDirection = "Up" }),
		},
		{
			key = "j",
			mods = "ALT",
			action = wezterm.action({ ActivatePaneDirection = "Down" }),
		},
		{
			key = "[",
			mods = "ALT",
			action = wezterm.action({ ActivateTabRelative = -1 }),
		},
		{
			key = "]",
			mods = "ALT",
			action = wezterm.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "1",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 0 }),
		},
		{
			key = "2",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 1 }),
		},
		{
			key = "3",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 2 }),
		},
		{
			key = "4",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 3 }),
		},
		{
			key = "5",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 4 }),
		},
		{
			key = "6",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 5 }),
		},
		{
			key = "7",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 6 }),
		},
		{
			key = "8",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 7 }),
		},
		{
			key = "9",
			mods = "ALT",
			action = wezterm.action({ ActivateTab = 8 }),
		},
	},
}

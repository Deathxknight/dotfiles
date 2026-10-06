-- Main Hyprland configuration
-- All modules are loaded from the same directory

local config_dir = os.getenv("HOME") .. "/.config/hypr/"

-- Load modules in order (dependencies matter)
require(config_dir .. "programs")       -- Defines _G.terminal, _G.browser, etc.
require(config_dir .. "env")            -- Environment variables
require(config_dir .. "monitors")       -- Monitor setup
require(config_dir .. "autostart")      -- Startup programs
require(config_dir .. "input")          -- Input devices & gestures
require(config_dir .. "look-and-feel")  -- Colors, decorations, gaps
require(config_dir .. "animations")     -- Animation curves & rules
require(config_dir .. "keybinds")       -- Keybindings (depends on programs.lua)
require(config_dir .. "window-rules")   -- Window rules (should be last)

-- Don't use hl.load_plugin() - it doesn't exist!

-- Configure Hyprglass (it should already be loaded by hyprpm or hyprland.conf)
require(config_dir .. "hyprglass")

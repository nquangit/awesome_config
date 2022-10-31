-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
require("collision")()
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Local widget
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")

local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

-- Font
beautiful.font = "FontAwesome 12"

-- Load Debian menu entries
-- local debian = require("debian.menu")
-- local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
modkey_alt = "Mod1"
modkey_ctrl = "Control"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    --awful.layout.suit.floating,
    awful.layout.suit.tile
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end },
-- }

-- local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
-- local menu_terminal = { "open terminal", terminal }

-- if has_fdo then
--     mymainmenu = freedesktop.menu.build({
--         before = { menu_awesome },
--         after =  { menu_terminal }
--     })
-- else
--     mymainmenu = awful.menu({
--         items = {
--                   menu_awesome,
--                   { "Debian", debian.menu.Debian_menu.Debian },
--                   menu_terminal,
--                 }
--     })
-- end


-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- cpuwidget_text = wibox.widget.textbox()

-- vicious.register(cpuwidget_text, vicious.widgets.cpu, ' $1% $2% $3% $3% ', 3)

-- cpuwidget = wibox.widget {

-- { widget = cpuwidget_text },

-- bg = "#4B696D",

-- fg = beautiful.fg_focus,

-- widget = wibox.container.background,

-- shape = function(cr, w, h, ...)

-- local f = gears.shape.transform(gears.shape.powerline):rotate_at(w/2, h/2, math.pi)

-- f(cr, w, h, ...)

-- end

-- }

-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock.format = " %a %d %b - %H:%M "
mytextclock.font = "FontAwesome 12"
-- default
-- local cw = calendar_widget()
-- or customized
local cw = calendar_widget({
    theme = 'nord',
    placement = 'top_center',
    start_sunday = false,
    radius = 8,
    -- with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 1,
})

mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)

-- Create a wibox for each screen and add it
-- local taglist_buttons = gears.table.join(
--                     awful.button({ }, 1, function(t) t:view_only() end),
--                     awful.button({ modkey }, 1, function(t)
--                                               if client.focus then
--                                                   client.focus:move_to_tag(t)
--                                               end
--                                           end),
--                     awful.button({ }, 3, awful.tag.viewtoggle),
--                     awful.button({ modkey }, 3, function(t)
--                                               if client.focus then
--                                                   client.focus:toggle_tag(t)
--                                               end
--                                           end),
--                     awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
--                     awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
--                 )

-- local tasklist_buttons = gears.table.join(
--                      awful.button({ }, 1, function (c)
--                                               if c == client.focus then
--                                                   c.minimized = true
--                                               else
--                                                   c:emit_signal(
--                                                       "request::activate",
--                                                       "tasklist",
--                                                       {raise = true}
--                                                   )
--                                               end
--                                           end),
--                      awful.button({ }, 3, function()
--                                               awful.menu.client_list({ theme = { width = 250 } })
--                                           end),
--                      awful.button({ }, 4, function ()
--                                               awful.client.focus.byidx(1)
--                                           end),
--                      awful.button({ }, 5, function ()
--                                               awful.client.focus.byidx(-1)
--                                           end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "a", "w", "e", "s", "o", "m", "e", "w", "m"}, s, awful.layout.layouts[1])
    -- awful.tag({ "A", "W", "E", "S", "O", "M", "E", "W", "M"}, s, awful.layout.layouts[1])


    -- Create a promptbox for each screen
    -- s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    -- s.mylayoutbox = awful.widget.layoutbox(s)
    -- s.mylayoutbox:buttons(gears.table.join(
    --                        awful.button({ }, 1, function () awful.layout.inc( 1) end),
    --                        awful.button({ }, 3, function () awful.layout.inc(-1) end),
    --                        awful.button({ }, 4, function () awful.layout.inc( 1) end),
    --                        awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        -- style   = {
        --    shape = gears.shape.powerline
        -- },
        -- layout   = {
        --     -- spacing = -20,
        --     layout  = wibox.layout.ratio.horizontal,
        -- },
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 5,
                right = 5,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
        buttons = taglist_buttons,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        -- filter  = awful.widget.tasklist.filter.currenttags,
        -- buttons = tasklist_buttons
    }
    
    -- Create the systray
    beautiful.systray_icon_spacing = 10
    beautiful.systray_icon_size = 50
    s.systray = wibox.widget.systray()
    s.systray.visible = false
    -- systray.forced_height = 100
    -- systray.forced_width = 100
    -- wibox.container.margin(systray, 50, 50, 50, 50)


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32, opacity = 0.9 })
    -- s.mywibox_1 = awful.wibar({ position = "left", screen = s, width = 32, opacity = 0.9, type = "dock" })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = -10,
            -- mylauncher,
            -- s.mytaglist,
            {
                s.mytaglist,
                top = 0,
                bottom = 0,
                right = 10,
                left = 10,
                widget = wibox.container.margin,
            },
            -- s.mypromptbox,
            {
                {
                    ram_widget({
                        timeout = 5,
                    }),
                    top = 0,
                    bottom = 0,
                    right = 20,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.powerline(cr, width, height, 15)
                                    end,
                bg                 = "#34495e",
                widget             = wibox.container.background
            },
            {
                {
                    fs_widget(), --default
                    -- fs_widget({ mounts = { '/', '/mnt/music' } }), -- multiple mounts
                    top = 0,
                    bottom = 0,
                    right = 20,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.powerline(cr, width, height, 15)
                                    end,
                bg                 = "#34495e",
                widget             = wibox.container.background
            },
        },
        -- Middle widget
        wibox.container.place(
            mytextclock,
            'center',
            'center'
        ),
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = -10,
            -- mykeyboardlayout,
            s.systray,
            {
                {
                    net_speed_widget({
                        timeout = 1,
                        width = 60,
                        interface = "*",
                    }),
                    top = 0,
                    bottom = 0,
                    right = 20,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.powerline(cr, width, height, -15)
                                    end,
                bg                 = "#234363",
                widget             = wibox.container.background
            },
            {
                {
                    todo_widget(),
                    top = 0,
                    bottom = 0,
                    right = 20,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.powerline(cr, width, height, -15)
                                    end,
                bg                 = "#34495e",
                widget             = wibox.container.background
            },
            {
                {
                    volume_widget{
                        -- horizontal_bar, vertical_bar, icon, icon_and_text, arc
                        widget_type = 'arc',
                        size = 25,
                        mute_color = "#fa5252",
                        thickness = 2, 
                    },
                    top = 0,
                    bottom = 0,
                    right = 20,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.powerline(cr, width, height, -15)
                                    end,
                bg                 = "#34495e",
                widget             = wibox.container.background
            },
            {
                {
                    -- batteryarc_widget({
                    --     show_current_level = true,
                    --     font = "FontAwesome 8",
                    --     arc_thickness = 2,
                    --     size = 25,
                    --     bg_color = "#f1f1f1",
                    -- }),
                    battery_widget({
                        font = "FontAwesome 10",
                        show_current_level = true,
                        display_notification = true,
                        
                    }),
                    top = 0,
                    bottom = 0,
                    right = 20,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.powerline(cr, width, height, -15)
                                    end,
                bg                 = "#34495e",
                widget             = wibox.container.background
            },
            {
                {
                    brightness_widget({
                        type = 'icon_and_text',
                        program = 'brightnessctl',
                        step = 5,
                        percentage = true,
                        font = 'FontAwesome 11',
                    }),
                    top = 0,
                    bottom = 0,
                    right = 10,
                    left = 20,
                    widget = wibox.container.margin,
                },
                shape              = function(cr, width, height)
                                        gears.shape.rectangular_tag(cr, width, height, 15)
                                    end,
                bg                 = "#34495e",
                widget             = wibox.container.background
            },
            -- s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ modkey }, 4, awful.tag.viewnext),
    awful.button({ modkey }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey_ctrl, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Rofi
    awful.key({ modkey },            "r",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/dmenu_rofi/launcher_run.sh")
    end,
              {description = "run prompt with rofi like dmenu", group = "launcher"}),

    awful.key({ modkey, "Shift" },            "r",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/dmenu_rofi/launcher_drun.sh")
    end,
              {description = "drun prompt with rofi like dmenu", group = "launcher"}),

    awful.key({ modkey, "Shift" },            "s",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/bin/custom/launcher_colorful_window.sh")
    end,
              {description = "window prompt with rofi like dmenu", group = "launcher"}),

    awful.key({ modkey },            "Print",     function ()
      awful.util.spawn("flameshot gui")
    end,
              {description = "Take screenshot", group = "launcher"}),

    awful.key({ "Shift", modkey_alt },            "t",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/bin/custom/applet_time")
    end,
              {description = "Show time", group = "Information"}),

    awful.key({ "Shift", modkey_alt },            "n",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/bin/custom/applet_network")
    end,
              {description = "Show network", group = "Information"}),

    awful.key({ "Shift", modkey_alt },            "v",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/bin/custom/applet_volume")
    end,
              {description = "Show volumn", group = "Information"}),

    awful.key({ "Shift", modkey_alt },            "b",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/bin/custom/applet_battery")
    end,
              {description = "Show battery", group = "Information"}),

    awful.key({ "Shift", modkey_alt },            "z",     function ()
      awful.util.spawn("/home/nquang/.config/rofi/bin/custom/applet_apps")
    end,
              {description = "Most used apps", group = "Information"}),

    --    awful.key({ modkey_alt, "v" },             "Up",       function ()
    --      awful.util.spawn("amixer -q set Master 5%+")
    --    end,
    --              {description = "Volume up", group = "Control"}),
    --
    --    awful.key({ modkey_alt, "v" },             "Down",       function ()
    --      awful.util.spawn("amixer -q set Master 5%-")
    --    end,
    --              {description = "Volume down", group = "Control"}),

    awful.key({ modkey_alt, "Control" },             "l",        function()
       logout_popup.launch() 
    end, 
              {description = "Show logout screen", group = "power menu"}),

    -- Adjust brightness
    awful.key({ modkey         }, ";", function () brightness_widget:inc() end, {description = "increase brightness", group = "brightness"}),
    awful.key({ modkey, "Shift"}, ";", function () brightness_widget:dec() end, {description = "decrease brightness", group = "brightness"}),

    awful.key({ modkey         }, "=", function ()
         awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
    end,
                                 {description = "Toggle systray visibility", group = "System tray"}),

    awful.key({ modkey , "Control" }, "v", function ()
         awful.util.spawn("copyq show")
    end,
                                 {description = "Clipboard history", group = "System tray"}),

    awful.key({ modkey }, "]", function() volume_widget:inc(5) end),
    awful.key({ modkey }, "[", function() volume_widget:dec(5) end),
    awful.key({ modkey }, "\\", function() volume_widget:toggle() end)


    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})

    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
    --   }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--     )

--     awful.titlebar(c) : setup {
--         { -- Left
--             awful.titlebar.widget.iconwidget(c),
--             buttons = buttons,
--             layout  = wibox.layout.fixed.horizontal
--         },
--         { -- Middle
--             { -- Title
--                 align  = "center",
--                 widget = awful.titlebar.widget.titlewidget(c)
--             },
--             buttons = buttons,
--             layout  = wibox.layout.flex.horizontal
--         },
--         { -- Right
--             awful.titlebar.widget.floatingbutton (c),
--             awful.titlebar.widget.maximizedbutton(c),
--             awful.titlebar.widget.stickybutton   (c),
--             awful.titlebar.widget.ontopbutton    (c),
--             awful.titlebar.widget.closebutton    (c),
--             layout = wibox.layout.fixed.horizontal()
--         },
--         layout = wibox.layout.align.horizontal
--     }
-- end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Gaps
beautiful.useless_gap = 6

-- Auto start

-- awful.spawn.with_shell("/home/nquang/.config/polybar/launch.sh")
awful.spawn.with_shell("/home/nquang/.config/picom/launcher.sh")
awful.spawn.with_shell("killall -qw feh; feh --bg-fill --randomize /usr/share/backgrounds/kali-16x9/")

-- awful.spawn.with_shell("killall -q xfce4-clipman; xfce4-clipman")
awful.spawn.with_shell("killall -qw copyq; copyq --start-server")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("kmix --failsafe")
-- awful.spawn.with_shell("killall -q flameshot; flameshot")
-- awful.spawn.with_shell("/home/nquang/.config/awesome/script/redshift.sh")

-- Lock screen 
awful.spawn.with_shell("xautolock -time 20 -locker \"/home/nquang/.config/betterlockscreen/lock.sh\"")

-- Notification with dunst
-- awful.spawn.with_shell("/home/nquang/.config/dunst/launcher.sh")


-- Notification theme
beautiful.notification_border_width = 10 
beautiful.notification_margin = 10
naughty.config.padding = 10
naughty.config.spacing = 3
naughty.config.defaults.timeout = 10
naughty.config.defaults.margin = 15
naughty.config.defaults.border_width = 2

naughty.config.notify_callback = function(args)
         -- args.text = 'prefix: ' .. args.text
         if args.title ~= "Battery status" and args.title
         then
             notify_cache = io.open("/home/nquang/.cache/notify_cache.txt", 'a')
             notify_cache:write("\n")
             notify_cache:write(os.date("!%c"))
             notify_cache:write(": ")
             notify_cache:write(args.title)
             notify_cache:write(" - ")
             txt = args.text:gsub("\n", "\\n")
             notify_cache:write(txt)
             notify_cache:close()
         end
         return args
     end

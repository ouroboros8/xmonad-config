import System.IO
import Data.List(intercalate) -- for long strings
import Data.Map
import Data.Maybe

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Hooks.FadeInactive
import XMonad.Actions.CycleWS

---------------------
-- Basic behaviour --
---------------------

myTerminal = "urxvt"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myModMask = mod4Mask

myBorderWidth = 0

-----------------
-- Keybindings --
-----------------

myRestart = intercalate ""
            [ "xmonad --recompile"
            , " && for pid in $(pgrep dzen2); do kill $pid; done;"
            , " for pid in $(pgrep conky); do kill $pid; done"
            , " && xmonad --restart"
            ]

myKeys =
    [ ((mod4Mask, xK_w), spawn "firefox")
    , ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    {-, ((mod1Mask .|. controlMask, xK_a), spawn "keepass --auto-type")-}
    , ((controlMask .|. mod4Mask, xK_r), spawn myRestart)
    ] 

---------------
-- myLogHook --
---------------

fadeLogHook :: X ()
fadeLogHook = fadeInactiveCurrentWSLogHook fadeAmount
    where fadeAmount = 0.95

--------------
-- myLayout --
--------------

myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-----------
-- dzen2 --
-----------

-- Theme:
colors = fromList
    [("Black",       "#282828")
    ,("DarkGrey",    "#7c6f64")
    ,("DarkRed",     "#cc241d")
    ,("Red",         "#fb4934")
    ,("DarkGreen",   "#98971a")
    ,("Green",       "#b8bb26")
    ,("DarkYellow",  "#d79921")
    ,("Yellow",      "#fabd2f")
    ,("DarkBlue",    "#458588")
    ,("Blue",        "#83a598")
    ,("DarkMagenta", "#b16286")
    ,("Magenta",     "#d3869b")
    ,("DarkCyan",    "#689d6a")
    ,("Cyan",        "#8ec07c")
    ,("LightGrey",   "#bdae93")
    ,("White",       "#ebdbb2")
    ]


bgcol :: String
bgcol = "#1D1D1D"
fgcol :: String
fgcol  = fromJust (Data.Map.lookup "White" colors)
curcol :: String
curcol = fromJust (Data.Map.lookup "Yellow" colors)
viscol :: String
viscol = fromJust (Data.Map.lookup "DarkYellow" colors)
titlecol :: String
titlecol = fromJust (Data.Map.lookup "DarkMagenta" colors)
urgcol :: String
urgcol = fromJust (Data.Map.lookup "DarkRed" colors)

dzenLogHook :: Handle -> X ()
dzenLogHook h = dynamicLogWithPP $ defaultPP
    { ppCurrent           =   dzenColor curcol bgcol . pad . wrap "[" "]"
    , ppVisible           =   dzenColor viscol bgcol . pad . pad
    , ppHidden            =   dzenColor  fgcol bgcol . pad . pad
    , ppUrgent            =   dzenColor  fgcol bgcol . pad . wrap "¡" "!"
    , ppWsSep             =   " "
    , ppSep               =   "  |  "
    , ppTitle             =   (" " ++) . dzenColor titlecol bgcol . dzenEscape
    , ppOutput            =   hPutStrLn h
    }

myXMonadBar = intercalate ""
    [ "dzen2"
    -- position
    , " -x '0' -y '0'"
    -- dimensions
    , " -w '683' -h '22'"
    -- text alignment
    , " -ta 'l'"
    -- colours
    , " -bg " ++ show bgcol
    , " -fg " ++ show fgcol
    -- prevent default behaviour of exiting on mouse2
    , " -e 'button2='"
    ]

myConkyStatusBar = intercalate ""
    -- First we need to set the lua path so that my lua scripts work
    [ "LUA_PATH=/home/dan/.xmonad/lua_lib/?.lua"
    -- then run conky
    , " conky -c /home/dan/.xmonad/conky_status 2> .xmonad/conky_status_err.log"
    -- pipe conky to dzen
    , " | dzen2"
    -- position
    , " -x '683' -y '0'"
    -- dimensions
    , " -w '683' -h '22'"
    -- text alignment
    , " -ta 'r'"
    -- colours
    , " -bg " ++ show bgcol
    , " -fg " ++ show fgcol
    -- prevent default behaviour of exiting on mouse2
    , " -e 'button2='"
    ]

myConkySysBar = intercalate ""
    [ "LUA_PATH=/home/dan/.xmonad/lua_lib/?.lua"
    , " conky -c /home/dan/.xmonad/conky_sysbar 2> .xmonad/conky_sys_err.log"
    , " | dzen2"
    , " -x '0' -y '768'"
    , " -w '1166' -h '20'"
    , " -ta 'l'"
    , " -bg " ++ show bgcol
    , " -fg " ++ show fgcol
    , " -e 'button2='"
    ]

myBitmapsDir = "/home/dan/.xmonad/dzen2"

----------
-- Main --
----------

main = do
    dzenXMonadBar <- spawnPipe myXMonadBar
    dzenConkyStatusBar <- spawnPipe myConkyStatusBar
    dzenConkySysBar <- spawnPipe myConkySysBar
    xmonad $ defaultConfig
        { terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , logHook            = dzenLogHook dzenXMonadBar >> fadeLogHook
        , layoutHook         = smartBorders $ myLayout
        , manageHook         = manageDocks <+> (isFullscreen --> doFullFloat) <+> manageHook defaultConfig
        } `additionalKeys` myKeys

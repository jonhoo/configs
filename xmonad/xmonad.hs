import XMonad
import qualified Data.Map as M
import Data.List
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import qualified XMonad.Hooks.EwmhDesktops as EWMH
import qualified XMonad.Layout.Fullscreen as FS
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import System.IO
import Control.Monad
import qualified XMonad.StackSet as W

myTerminal      = "urxvt"
myFocusFollowsMouse = False
myClickJustFocuses = False

myBorderWidth   = 1
myNormalBorderColor = "#212121"
myFocusedBorderColor = "#FF2121"

myModMask       = mod1Mask -- or mod4Mask for super
myWorkspaces    = ["web","code","a","b","mx","sfx"]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
	[ ((0, xK_Print), (spawn "scrot"))
	, ((mod4Mask, xK_a), (spawn myTerminal))
	, ((mod4Mask, xK_f), (spawn "firefox"))
	, ((mod4Mask, xK_q), (spawn "/usr/bin/bash -c 'notify-send -i time \"Right now, it is\" \"$(date \"+%-I:%M %p, %A %B %d, %Y\")\n$(acpi | sed \"s/Battery 0://\")\"'"))
	, ((mod4Mask, xK_e), (spawn "urxvt -e /bin/bash -ic \"mutt -e 'source ~/.mutt/account.fm'\""))
	, ((modm, xK_Print), (spawn "scrot -s"))
	, ((mod4Mask, xK_l), (spawn "slock"))
	, ((mod4Mask, xK_j), (spawn "sudo ~jon/bin/hotplug-dp.sh &"))
	, ((0, xF86XK_AudioLowerVolume), (spawn "amixer set Master 5%- unmute &"))
	, ((0, xF86XK_AudioRaiseVolume), (spawn "amixer set Master 5%+ unmute &"))
	, ((0, xF86XK_AudioMute), (spawn "amixer set Master toggle &"))
	, ((0, xF86XK_Display), (spawn "sudo ~jon/bin/hotplug-dp.sh &"))
	, ((0, xF86XK_AudioPlay), (spawn "~/bin/spotify-control.sh start &"))
	, ((0, xF86XK_AudioNext), (spawn "~/bin/spotify-control.sh next &"))
	, ((0, xF86XK_AudioPrev), (spawn "~/bin/spotify-control.sh prev &"))
	, ((controlMask .|. mod1Mask, xK_Right), nextWS)
	, ((controlMask .|. mod1Mask, xK_Left), prevWS)
	, ((controlMask .|. mod1Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
	, ((controlMask .|. mod1Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
	] 

myLayout = (smartBorders tiled) ||| (smartBorders $ Mirror tiled) ||| (smartBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = toRational (2 / (1 + sqrt 5 :: Double))

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , className =? "transmission-gtk" --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "kupfer.py"      --> doIgnore
    , fmap (isInfixOf "mutt") appCommand --> doFShift "mx"
    , className =? "Firefox"        --> doFShift "web"
    , className =? "Spotify"        --> doFShift "sfx"
    , isFullscreen                  --> doFullFloat
    , FS.fullscreenManageHook
    , manageDocks
    ]
    where
	appCommand = stringProperty "WM_COMMAND"
	doFShift = doF . liftM2 (.) W.greedyView W.shift

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
main = do
	xmproc <- spawnPipe "xmobar"
	xmonad $ EWMH.ewmh $ defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
	normalBorderColor  = myNormalBorderColor,
	focusedBorderColor = myFocusedBorderColor,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        keys               = \c -> myKeys c `M.union` keys defaultConfig c,
        layoutHook         = avoidStruts $ myLayout,
        manageHook         = myManageHook,
	handleEventHook    = EWMH.fullscreenEventHook,
	logHook = dynamicLogWithPP $ xmobarPP
		{ ppOutput = hPutStrLn xmproc
		, ppTitle = xmobarColor "green" "" . shorten 70
		, ppHiddenNoWindows = xmobarColor "grey" "" 
		}
    }

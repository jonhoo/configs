import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.MPRIS
import Graphics.UI.Gtk

textWidgetNew :: String -> IO Widget
textWidgetNew str = do
	box <- hBoxNew False 0
	label <- labelNew $ Just str
	boxPackStart box label PackNatural 0
	widgetShowAll box
	return $ toWidget box

main = do
  let clock = textClockNew Nothing "%-I:%M %p, %A %B %d" 1
      pager = taffyPagerNew defaultPagerConfig {widgetSep = " :: "}
      mpris = mprisNew
      tray = systrayNew
      sep = textWidgetNew " ::"
  defaultTaffybar defaultTaffybarConfig { startWidgets = [ clock, sep, pager ]
                                        , endWidgets = [ mpris, tray ]
					, barHeight = 20
					, widgetSpacing = 0
					, barPosition = Bottom
                                        }

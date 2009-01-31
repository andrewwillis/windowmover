#
#  front_window.rb
#  WindowMover
#
#  Created by Andrew Willis on 1/23/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class FrontWindow < WWFrontWindow

  # this method just switches the current window to the next screen
  def toggleScreen
    next_screen = currentScreen + 1
	next_screen = 0 if next_screen == NSScreen.screens.length
	moveToScreen(next_screen)
  end
  
  # the cocoa drawing system puts 0,0 at the lower left of the screen, but 
  # the quickdraw system puts it at the upper left.  This converts to the 
  # cocoa system.
  def cocoaOrigin
	new_origin = frame.origin
	new_origin.y = NSScreen.mainScreen.frame.size.height - new_origin.y
	new_origin
  end
  
  def moveToScreen(screen_index)
  	relative_point = findRelativePosition
	new_top_left = NSPoint.new
	target_screen = NSScreen.screens[screen_index]
	target_frame = target_screen.visibleFrame
	new_top_left.x = target_frame.origin.x + (relative_point.x * target_frame.size.width)
	new_top_left.y = target_frame.origin.y + (relative_point.y * target_frame.size.height)
	
	# we have to convert back to the quickdraw coordinate system
	new_top_left.y = NSScreen.mainScreen.frame.size.height - new_top_left.y
	setFrameTopLeftPoint(new_top_left)
  end
  
  def currentScreen
    top_left = cocoaOrigin
	NSScreen.screens.each_with_index do |screen, index|
	  screen_frame = screen.visibleFrame
	  NSLog("comparing point #{NSStringFromPoint(top_left)} with #{NSStringFromRect(screen_frame)}")
	  if (top_left.x >= screen_frame.origin.x) &&
	     (top_left.x <= (screen_frame.origin.x + screen_frame.size.width)) &&
		 (top_left.y >= screen_frame.origin.y) && 
		 (top_left.y <= (screen_frame.origin.y + screen_frame.size.height))
	  
#	  (NSPointInRect(top_left, screen_frame))
        return index
	  end
	end
	raise "Could not find screen for current window - top_left at #{top_left.x}x#{top_left.y}"
  end
  
  def findRelativePosition
    top_left = cocoaOrigin
	relative_point = NSPoint.new
	
	screen_frame = NSScreen.screens[currentScreen].visibleFrame
    relative_point.x = (top_left.x - screen_frame.origin.x) / screen_frame.size.width
    relative_point.y = (top_left.y - screen_frame.origin.y) / screen_frame.size.height
	
	relative_point
  end
end

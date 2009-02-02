#
#  TestHarness.rb
#  WindowMover
#
#  Created by Andrew Willis on 1/22/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class TestHarness
  attr_writer :menu
  
  def awakeFromNib
  
	# register the hotkey
    @hotkey = NDHotKeyEvent.hotKeyWithKeyCode(46, character:46, modifierFlags: (NSCommandKeyMask + NSShiftKeyMask))
	@hotkey.setTarget(self, selector:("buttonClicked:"))
	@hotkey.setEnabled(true)
	
	# create the status item
	bundle = NSBundle.bundleForClass(self.class)
	icon_path = bundle.pathForResource("menubar_icon", ofType:"tif")
	status_item = NSStatusBar.systemStatusBar.statusItemWithLength(24) # TODO: why is 24 the right size here?
	status_item.image = NSImage.new.initWithContentsOfFile(icon_path)
	status_item.menu = @menu
  end
  
  def statusItemClicked(sender)
	NSApp.terminate(sender)
  end
  
  def buttonClicked(sender)
	puts "button clicked"
	front = FrontWindow.new
	frame = front.frame
	NSLog("front window at x=#{frame.origin.x}, y=#{frame.origin.y}")
	front.toggleScreen
  end
end

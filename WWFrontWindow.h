//
//  WWFrontWindow.h
//  WindowMover
//
//  Created by Andrew Willis on 1/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>


@interface WWFrontWindow : NSObject {
	AXUIElementRef mFrontWindow;
}
- init;
- (OSStatus)getFrontAppPID:(pid_t *)front_pid;
- (NSRect)frame;
- (void)setFrameTopLeftPoint:(NSPoint)point;
@end

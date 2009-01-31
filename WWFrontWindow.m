//
//  WWFrontWindow.m
//  WindowMover
//
//  Created by Andrew Willis on 1/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WWFrontWindow.h"

@implementation WWFrontWindow

- init
{	
	pid_t front_pid;
	AXUIElementRef front_app;
	OSStatus err;
	NSString * title;

	err = [self getFrontAppPID:&front_pid];
	
	if (err != 0) {
		NSLog(@"Error with GetProcessPID");
	}
	
	front_app = AXUIElementCreateApplication(front_pid);
	
	err = AXUIElementCopyAttributeValue(front_app, kAXTitleAttribute, &title);
	NSLog(@"Front window is %@", title);
	
	err = AXUIElementCopyAttributeValue(front_app, kAXFocusedWindowAttribute, &mFrontWindow);
	
	return self;
}

- (NSRect)frame
{
	CFTypeRef temp_value;
	CGPoint location;
	CGSize size;
	OSStatus err;


	/* get the x and y coordinates of the window */
	err = AXUIElementCopyAttributeValue(mFrontWindow, kAXPositionAttribute, &temp_value);
	if (!AXValueGetValue(temp_value, kAXValueCGPointType, &location)) {
		NSLog(@"AXValueGetValue had a problem");
	}

	/* get the size of the window */
	err = AXUIElementCopyAttributeValue(mFrontWindow, kAXSizeAttribute, &temp_value);
	if (!AXValueGetValue(temp_value, kAXValueCGSizeType, &size)) {
		NSLog(@"AXValueGetValue had a problem");
	}
	
	return NSMakeRect(location.x, location.y, size.width, size.height);
}


- (OSStatus)getFrontAppPID:(pid_t *)front_pid
{
	NSDictionary * active_app_dictionary;
	NSNumber * serial_high;
	NSNumber * serial_low;
	ProcessSerialNumber psn;

	active_app_dictionary = [[NSWorkspace sharedWorkspace] activeApplication];
	serial_high = [active_app_dictionary objectForKey:@"NSApplicationProcessSerialNumberHigh"];
	serial_low = [active_app_dictionary objectForKey:@"NSApplicationProcessSerialNumberLow"];
	
	psn.highLongOfPSN = [serial_high unsignedLongValue];
	psn.lowLongOfPSN = [serial_low unsignedLongValue];
	
	return GetProcessPID(&psn, front_pid);

}


- (void)setFrameTopLeftPoint:(NSPoint)point
{
	CGPoint location;
	CFTypeRef temp_value;
	OSStatus err;
	
	NSLog(@"Moving to point %f x %f", point.x, point.y);
	location = NSPointToCGPoint(point); 
	
	temp_value = AXValueCreate(kAXValueCGPointType, &location);
	err = AXUIElementSetAttributeValue(mFrontWindow, kAXPositionAttribute, temp_value);
	if (err != 0) {
		NSLog(@"Error with AXUIElementSetAttributeValue");
	}
}

@end

//
//  Driver.m
//  Rainbow
//
//  Created by Praneet S on 26/10/21.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Driver.h"

@implementation DriverObject

- (NSColor*) runLoop {
    
    @autoreleasepool {
        
        CGPoint mouseLoc = CGEventGetLocation(CGEventCreate(NULL));
        
        // Grab the display for said mouse location.
        CGDirectDisplayID displayForPoint;
        uint32_t count = 0;
        if (CGGetDisplaysWithPoint(NSPointToCGPoint(mouseLoc), 1, &displayForPoint, &count) != kCGErrorSuccess)
        {
            NSLog(@"Oops.");
            return 0;
        }
        
        // Grab the color on said display at said mouse location.
        CGImageRef image = CGDisplayCreateImageForRect(displayForPoint, CGRectMake(mouseLoc.x, mouseLoc.y, 1, 1));
        NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
        CGImageRelease(image);
        NSColor* color = [bitmap colorAtX:0 y:0];
        
//        [NSApp setApplicationIconImage: [NSImage swatchWithColor:color size:CGSizeMake(64, 64)]];;
        return color;
    }
}

@end

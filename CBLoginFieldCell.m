//
//  CBLoginFieldCell.m
//  Podcasts
//
//  Created by Chris Brakebill on 5/10/14.
//  Copyright (c) 2014 Chris Brakebill. All rights reserved.
//

#import "CBLoginFieldCell.h"

@implementation CBLoginFieldCell

- (NSRect)drawingRectForBounds:(NSRect)theRect{
    return [super drawingRectForBounds:theRect];
}

- (NSRect)titleRectForBounds:(NSRect)theRect

{
    
    NSRect titleFrame = [super titleRectForBounds:theRect];

    //Padding on left side
    titleFrame.origin.x = 10;
    titleFrame.origin.y = 5;
    
    
    //Padding on right side
    titleFrame.size.width -= (2 * 10);
    titleFrame.size.height -= (2 *5);
    
    return titleFrame;
    
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent

{
    NSRect textFrame = aRect;
    
    textFrame.origin.x += 10;
    textFrame.origin.y += 5;
    
    textFrame.size.width -= (2* 10);
    textFrame.size.height -= (2*5);
    
    [super editWithFrame: textFrame inView: controlView editor:textObj delegate:anObject event: theEvent];
    
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength

{
    NSRect textFrame = aRect;

    textFrame.origin.x += 10;
    textFrame.origin.y += 5;
    
    textFrame.size.width -= (2* 10);
    textFrame.size.height -= (2*5);
    
    
    [super selectWithFrame: textFrame inView: controlView editor:textObj delegate:anObject start:selStart length:selLength];
    
}


-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    [super drawWithFrame:titleRect inView:controlView];
}


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView*)controlView

{
    NSRect titleRect = [super titleRectForBounds:cellFrame];
    [super drawInteriorWithFrame:titleRect inView:controlView];
    
}


-(BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag
{
    return [super trackMouse:theEvent inRect:cellFrame ofView:controlView untilMouseUp:flag];
}

@end

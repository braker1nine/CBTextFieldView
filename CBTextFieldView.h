//
//  CBTextFieldView.h
//  Podcasts
//
//  Created by Chris Brakebill on 5/23/14.
//  Copyright (c) 2014 Chris Brakebill. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CBTextFieldView : NSView <NSTextFieldDelegate> {
    CALayer *_selectedLayer;
    BOOL _selected;
    CATextLayer *_placeholderLayer;
}

@property (nonatomic, assign) BOOL secure;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) NSColor *selectedColor;
@property (nonatomic, strong) NSString *placeholderString;

-(void)selectedTextField:(NSTextField *)textField;
-(void)deselectedTextField:(NSTextField *)textField;

@end

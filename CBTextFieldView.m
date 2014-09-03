//
//  CBTextFieldView.m
//  Podcasts
//
//  Created by Chris Brakebill on 5/23/14.
//  Copyright (c) 2014 Chris Brakebill. All rights reserved.
//

#import "CBTextFieldView.h"

#import "CBLoginFieldCell.h"
#import "CBSecureTextFieldCell.h"

#import <POP/POP.h>

@implementation CBTextFieldView

NSTimer  *theTimer;
bool hasFocus(id theField) {
    return   [[[theField window] firstResponder] isKindOfClass:[NSTextView class]]
    &&        [[theField window] fieldEditor:NO forObject:nil]!=nil
    && ( (id) [[theField window] firstResponder]          ==theField
        ||  [(id) [[theField window] firstResponder] delegate]==theField); }

-(id)initWithFrame:(NSRect)frameRect secure:(BOOL)secure
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _secure = secure;
        [self setWantsLayer:YES];
        //self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self _initializeTextField];
        
        _selectedColor = [NSColor colorWithRed:0.98 green:0.3 blue:0.98 alpha:1.0];
        _selectedLayer = [CALayer layer];
        _selectedLayer.backgroundColor = _selectedColor.CGColor;
        _selectedLayer.frame = CGRectMake(_textField.frame.origin.x, _textField.frame.origin.y, 0, _textField.frame.size.height);
        _selectedLayer.zPosition = 1.0;
        [self.layer addSublayer:_selectedLayer];
        
        if (hasFocus(_textField)) {
            [self selectedTextField:_textField];
        } else {
            [self deselectedTextField:_textField];
        }
        theTimer= [NSTimer scheduledTimerWithTimeInterval:.1
                                                   target:self
                                                 selector:@selector(_checkFocusChange)
                                                 userInfo:nil
                                                  repeats:YES];
        
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    return [self initWithFrame:frame secure:NO];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)setSecure:(BOOL)secure
{
    _secure = secure;
    [self _initializeTextField];
    // Redraw the textfield with a secure textfield
}

-(void)setPlaceholderString:(NSString *)placeholderString
{
    _placeholderString = placeholderString;
    if (_placeholderLayer == nil && _placeholderString != nil && _placeholderString.length > 0) {
        _placeholderLayer = [CATextLayer layer];
        [_placeholderLayer setFrame:[self _placeholderFrame]];
        _placeholderLayer.string = _placeholderString;
        [_placeholderLayer setFontSize:11.0];
        _placeholderLayer.foregroundColor = [NSColor colorWithWhite:0.4 alpha:1.0].CGColor;
        _placeholderLayer.zPosition = 2.0;
        _placeholderLayer.shouldRasterize = NO;
        _placeholderLayer.contentsScale = [[NSScreen mainScreen] backingScaleFactor];
        [self.layer addSublayer:_placeholderLayer];
    }
}

-(void)_checkFocusChange
{
    BOOL focusedNow = hasFocus(_textField);
    if (focusedNow != _selected) {
        _selected = focusedNow;
        if (focusedNow) {
            [self selectedTextField:_textField];
        } else {
            [self deselectedTextField:_textField];
        }
        
        [self _updatePlaceHolderFrame];
    }
}

-(void)_initializeTextField
{
    NSTextField *old = _textField;
    NSRect textRect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height-20);
    if (_secure) {
        _textField = [[NSSecureTextField alloc] initWithFrame:textRect];
        CBSecureTextFieldCell *cell = [[CBSecureTextFieldCell alloc] initTextCell:@""];
        [cell setEditable:YES];
        [cell setEnabled:YES];
        [_textField setCell:cell];
    } else {
        [NSTextField setCellClass:[CBLoginFieldCell class]];
        _textField = [[NSTextField alloc] initWithFrame:textRect];
    }
    
    _textField.delegate = self;
    _textField.backgroundColor = [NSColor clearColor];
    [_textField setBordered:NO];
    [_textField.cell setFocusRingType:NSFocusRingTypeNone];
    [_textField setFont:[NSFont fontWithName:@"AvenirNext-Regular" size:12.0]];
    [_textField setTextColor:[NSColor colorWithWhite:0.37 alpha:1.0]];
    [_textField setWantsLayer:YES];
    _textField.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    [self addSubview:_textField];
    [old removeFromSuperview];
}

-(BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    NSLog(@"Begin Editing");
    return YES;
}

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSLog(@"End Editing");
    return YES;
}

-(CGFloat)_placeholderTranslation
{
    if ((_textField.stringValue != nil && _textField.stringValue.length > 0) || _selected) {
        return 25;
    } else {
        return 0;
    }
}

-(CGRect)_placeholderFrame
{
    CGRect ret = CGRectInset(NSRectToCGRect(_textField.frame), 10, 8);
    return ret;
}

-(void)_updatePlaceHolderFrame
{
    CGRect newFrame = [self _placeholderFrame];

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
    positionAnimation.toValue = @([self _placeholderTranslation]);
    positionAnimation.springBounciness = 12.0f;
    positionAnimation.springSpeed = 12.0f;
    [_placeholderLayer pop_addAnimation:positionAnimation forKey:@"translation"];
    
}


-(CGFloat)_selectedColorWidth
{
    if (_selected) {
        return 10.0f;
    } else {
        return 0.0f;
    }
}

-(void)_updateSelectedColorFrame
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    positionAnimation.toValue = [NSValue valueWithCGRect:NSMakeRect(0, 0, [self _selectedColorWidth], _selectedLayer.bounds.size.height)];
    positionAnimation.springBounciness = 12.0f;
    positionAnimation.springSpeed = 12.0f;
    [_selectedLayer pop_addAnimation:positionAnimation forKey:@"width"];
}

-(void)selectedTextField:(NSTextField *)textField
{
    _selected = YES;
    [self _updatePlaceHolderFrame];
    [self _updateSelectedColorFrame];
}

-(void)deselectedTextField:(NSTextField *)textField
{
    _selected = NO;
    [self _updatePlaceHolderFrame];
    [self _updateSelectedColorFrame];
}

-(BOOL)acceptsFirstResponder
{
    return NO;
}

-(void)dealloc
{
    [theTimer invalidate];
}



@end

//
//  KSOTextInputEditTextField.m
//  KSOTextInputEditText
//
//  Created by Jason Anderson on 4/14/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "KSOTextInputEditTextField.h"

static const CGFloat kBorderHeight = 2.0;
static const CGFloat kBorderTopMargin = 8.0;
static const CGFloat kBorderBottomMargin = 8.0;
static const CGFloat kFloatingLabelTopMargin = 16.0;
static const CGFloat kFloatingLabelBottomMargin = 8.0;

@interface KSOTextInputEditTextField ()

@property (strong,nonatomic) NSAttributedString *attributedPlaceholderString;
@property (strong,nonatomic) UILabel *floatingLabel;
@property (strong,nonatomic) UIView *border;
@property (strong,nonatomic) UIView *accentBorder;

@end

@implementation KSOTextInputEditTextField

#pragma mark *** Subclass Overrides ***
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self _KSOTextInputEditTextFieldInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self _KSOTextInputEditTextFieldInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_floatingLabel setFrame:self.bounds];
    [self bringSubviewToFront:_floatingLabel];
    
    [_border setFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - kBorderHeight, CGRectGetWidth(self.bounds), kBorderHeight)];
    [self bringSubviewToFront:_border];
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    [super setBorderStyle:UITextBorderStyleNone];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:UIColor.clearColor];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:_accentColor];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder.length > 0) {
        [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder]];
    }

    [super setPlaceholder:@""];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    if (attributedPlaceholder.length > 0) {
        _attributedPlaceholderString = attributedPlaceholder;
        
        [_floatingLabel setAttributedText:_attributedPlaceholderString];
        [_floatingLabel sizeToFit];
        [self setNeedsLayout];
    }
    
    [super setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@""]];
}

#pragma mark *** Public Methods ***
#pragma mark Properties
@synthesize primaryColor = _primaryColor;
- (void)setPrimaryColor:(UIColor *)primaryColor
{
    _primaryColor = primaryColor ?: [self.class defaultPrimaryColor];
}

@synthesize secondaryColor = _secondaryColor;
- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    _secondaryColor = secondaryColor ?: [self.class defaultSecondaryColor];
}

@synthesize accentColor = _accentColor;
- (void)setAccentColor:(UIColor *)accentColor
{
    _accentColor = accentColor ?: [self.class defaultAccentColor];
    [self setTintColor:accentColor];
}

@synthesize disabledColor = _disabledColor;
- (void)setDisabledColor:(UIColor *)disabledColor
{
    _disabledColor = disabledColor ?: [self.class defaultDisabledColor];
}

#pragma mark *** Private Methods ***
+ (UIColor *)defaultPrimaryColor
{
    return UIColor.blackColor;
}

+ (UIColor *)defaultSecondaryColor
{
    return UIColor.darkGrayColor;
}

+ (UIColor *)defaultAccentColor
{
    return UIColor.blueColor;
}

+ (UIColor *)defaultDisabledColor
{
    return UIColor.lightGrayColor;
}

- (void)_KSOTextInputEditTextFieldInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    //override possible appearance proxy settings for UITextField with default values
    [[KSOTextInputEditTextField appearance] setBorderStyle:UITextBorderStyleNone];
    [[KSOTextInputEditTextField appearance] setBackgroundColor:UIColor.clearColor];
    
    if (self.placeholder.length > 0) {
        _attributedPlaceholderString = [[NSAttributedString alloc] initWithString:self.placeholder];
        [self setPlaceholder:@""];
    }
    
    if (self.attributedPlaceholder.length > 0) {
        _attributedPlaceholderString = self.attributedPlaceholder;
        [self setPlaceholder:@""];
    }
    
    [self setFloatingLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [_floatingLabel setBackgroundColor:UIColor.clearColor];
    [_floatingLabel setAttributedText:_attributedPlaceholderString];
    [_floatingLabel sizeToFit];
    [self addSubview:_floatingLabel];
    
    [self setBorder:[[UIView alloc] initWithFrame:CGRectZero]];
    [_border setBackgroundColor:_secondaryColor];
    [self addSubview:_border];
    
    [self setAccentBorder:[[UIView alloc] initWithFrame:CGRectZero]];
    [_accentBorder setBackgroundColor:_accentColor];
    [self addSubview:_accentBorder];
}

- (void)_textDidBeginEditingNotification:(NSNotification *)notification
{
    //move above edit area
    [self.floatingLabel setTextAlignment:NSTextAlignmentRight];
}

- (void)_textDidEndEditingNotification:(NSNotification *)notification
{
    if (self.text.length == 0) {
        //return to original location
        [self.floatingLabel setTextAlignment:NSTextAlignmentLeft];
    }
}

@end

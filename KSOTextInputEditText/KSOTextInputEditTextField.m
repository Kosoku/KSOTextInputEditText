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
#import <Stanley/KSTGeometryFunctions.h>

static const CGFloat kFloatingLabelScale = 0.7;
static const CGFloat kAnimationDuration = 0.2;
static const CGFloat kBorderHeight = 2.0;
static const CGFloat kBorderMargin = 8.0;
static const CGFloat kFloatingLabelTopMargin = 16.0;

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
    return UIColor.grayColor;
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
    [self setTextEdgeInsets:UIEdgeInsetsMake(kFloatingLabelTopMargin, 0, kBorderMargin, 0)];
    
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
    [_floatingLabel setFont:self.font];
    [_floatingLabel sizeToFit];
    [self addSubview:_floatingLabel];
    [_floatingLabel setFrame:CGRectMake(0, ((CGRectGetHeight(self.bounds) - CGRectGetHeight(_floatingLabel.frame)) * 0.5) + kBorderMargin, CGRectGetWidth(_floatingLabel.frame), CGRectGetHeight(_floatingLabel.frame))];
    
    [self setBorder:[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) + kBorderMargin, CGRectGetWidth(self.bounds), kBorderHeight)]];
    [_border setBackgroundColor:_secondaryColor ?: [self.class defaultSecondaryColor]];
    [self addSubview:_border];
    
    [self setAccentBorder:[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_border.frame), CGRectGetMinY(_border.frame), 0, kBorderHeight)]];
    [_accentBorder setBackgroundColor:_accentColor ?: [self.class defaultAccentColor]];
    [self addSubview:_accentBorder];
}

- (void)_textDidBeginEditingNotification:(NSNotification *)notification
{
    __weak KSOTextInputEditTextField *weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        KSOTextInputEditTextField *strongSelf = weakSelf;
        [_accentBorder setFrame:CGRectMake(CGRectGetMinX(_border.frame), CGRectGetMaxY(_border.frame) - kBorderHeight, CGRectGetWidth(_border.frame), kBorderHeight)];
        [_floatingLabel setTransform:CGAffineTransformMakeScale(kFloatingLabelScale, kFloatingLabelScale)];
        [_floatingLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(_floatingLabel.frame), CGRectGetHeight(_floatingLabel.frame))];
        [_floatingLabel setTextColor:_accentColor ?: [strongSelf.class defaultAccentColor]];
    } completion:nil];
}

- (void)_textDidEndEditingNotification:(NSNotification *)notification
{
    __weak KSOTextInputEditTextField *weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        KSOTextInputEditTextField *strongSelf = weakSelf;
        [_accentBorder setFrame:CGRectMake(CGRectGetMidX(_border.frame), CGRectGetMaxY(_border.frame) - kBorderHeight, 0, kBorderHeight)];
        [_floatingLabel setTextColor:_secondaryColor ?: [strongSelf.class defaultSecondaryColor]];
        
        if (strongSelf.text.length == 0) {
            [_floatingLabel setTransform:CGAffineTransformIdentity];
            [_floatingLabel setFrame:CGRectMake(0, ((CGRectGetHeight(strongSelf.bounds) - CGRectGetHeight(_floatingLabel.frame)) * 0.5), CGRectGetWidth(_floatingLabel.frame), CGRectGetHeight(_floatingLabel.frame))];
        }
    } completion:nil];
}

@end

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

@property (strong,nonatomic) NSLayoutConstraint *accentBorderZeroWidth;
@property (strong,nonatomic) NSLayoutConstraint *accentBorderFullWidth;

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

- (void)prepareForInterfaceBuilder
{
    [self _KSOTextInputEditTextFieldInit];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_floatingLabel setText:self.label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_floatingLabel sizeToFit];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:UIColor.clearColor];
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    [super setBorderStyle:UITextBorderStyleNone];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:_accentColor];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [_floatingLabel setTextColor:_disabledColor ?: [self.class defaultDisabledColor]];
    [_border setBackgroundColor:_disabledColor ?: [self.class defaultDisabledColor]];
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
    _accentColor = accentColor ?: [self defaultAccentColor];
    [self setTintColor:accentColor];
    [self.accentBorder setBackgroundColor:_accentColor];
    [self.floatingLabel setTextColor:_accentColor];
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

- (UIColor *)defaultAccentColor
{
    return self.tintColor;
}

+ (UIColor *)defaultDisabledColor
{
    return UIColor.lightGrayColor;
}

- (void)_KSOTextInputEditTextFieldInit
{
    _accentColor = [self defaultAccentColor];
    _secondaryColor = [self.class defaultSecondaryColor];

    
    [self setTextEdgeInsets:UIEdgeInsetsMake(kFloatingLabelTopMargin, 0, kBorderMargin, 0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    [self setFloatingLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    
    [_floatingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_floatingLabel setBackgroundColor:UIColor.clearColor];
    [_floatingLabel setText:_label];
    [_floatingLabel setFont:self.font];
    [_floatingLabel setTextColor:_secondaryColor];
    [_floatingLabel sizeToFit];
    [self addSubview:_floatingLabel];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[floatingLabel]" options:0 metrics:nil views:@{@"floatingLabel":_floatingLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[floatingLabel]" options:0 metrics:nil views:@{@"floatingLabel":_floatingLabel}]];
    
    [self setBorder:[[UIView alloc] initWithFrame:CGRectZero]];
    [_border setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_border addConstraint:[NSLayoutConstraint constraintWithItem:_border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kBorderHeight]];
    [_border setBackgroundColor:_secondaryColor ?: [self.class defaultSecondaryColor]];
    [self addSubview:_border];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[border]|" options:0 metrics:nil views:@{@"border":_border}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[border]|" options:0 metrics:nil views:@{@"border":_border}]];
    
    [self setAccentBorder:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setAccentBorderFullWidth:[NSLayoutConstraint constraintWithItem:_accentBorder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_border attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self setAccentBorderZeroWidth:[NSLayoutConstraint constraintWithItem:_accentBorder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0]];
    
    [_accentBorder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_accentBorder addConstraint:[NSLayoutConstraint constraintWithItem:_accentBorder attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kBorderHeight]];
    [_accentBorder addConstraint:_accentBorderZeroWidth];
    [_accentBorder setBackgroundColor:_accentColor];
    [self addSubview:_accentBorder];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_accentBorder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_border attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[border]|" options:0 metrics:nil views:@{@"border":_accentBorder}]];
}

- (void)_textDidBeginEditingNotification:(NSNotification *)notification
{
    [self layoutIfNeeded];
    [_accentBorder removeConstraint:_accentBorderZeroWidth];
    [self addConstraint:_accentBorderFullWidth];
    
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self layoutIfNeeded];
        [_floatingLabel setTransform:CGAffineTransformMakeScale(kFloatingLabelScale, kFloatingLabelScale)];
        [_floatingLabel setTextColor:_accentColor ?: [self.class defaultAccentColor]];
    } completion:^(BOOL finished) {
    }];
}

- (void)_textDidEndEditingNotification:(NSNotification *)notification
{
    [self layoutIfNeeded];
    [self removeConstraint:_accentBorderFullWidth];
    [_accentBorder addConstraint:_accentBorderZeroWidth];
    
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
        
        if (self.text.length == 0) {
            [_floatingLabel setTransform:CGAffineTransformIdentity];
            
            [_floatingLabel setTextColor:_secondaryColor ?: [self.class defaultSecondaryColor]];
            [_border setBackgroundColor:_secondaryColor ?: [self.class defaultSecondaryColor]];
        } else {
            [_floatingLabel setTextColor:_primaryColor ?: [self.class defaultPrimaryColor]];
            [_border setBackgroundColor:_primaryColor ?: [self.class defaultPrimaryColor]];
        }
    } completion:^(BOOL finished) {
    }];
}

@end

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

@interface KSOTextInputEditTextField ()

@property (strong,nonatomic) UILabel *floatingLabel;

@end

@implementation KSOTextInputEditTextField

- (void)_KSOTextInputEditTextFieldInit
{
    [self setPrimaryColor:UIColor.blackColor];
    [self setSecondaryColor:UIColor.darkGrayColor];
    [self setAccentColor:UIColor.blueColor];
    [self setDisabledColor:UIColor.lightGrayColor];
    
    //override possible appearance proxy settings for UITextField with default values
    [[KSOTextInputEditTextField appearance] setBorderStyle:UITextBorderStyleNone];
    [[KSOTextInputEditTextField appearance] setBackgroundColor:UIColor.clearColor];
    
    [self setTintColor:_accentColor];
}

#pragma mark *** Subclass Overrides ***
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
    [super setPlaceholder:placeholder];
    
    [_floatingLabel setText:placeholder];
}

#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setPrimaryColor:(UIColor *)primaryColor
{
    _primaryColor = primaryColor;
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    _secondaryColor = secondaryColor;
}

- (void)setAccentColor:(UIColor *)accentColor
{
    _accentColor = accentColor;
    
    [self setTintColor:_accentColor];
}

- (void)setDisabledColor:(UIColor *)disabledColor
{
    _disabledColor = disabledColor;
}

@end

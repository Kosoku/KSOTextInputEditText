//
//  KSOTextInputEditTextField.h
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

#import <Ditko/KDITextField.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSOTextInputEditTextField is a KDITextField subclass that adds a floating label and styling comparable to the TextInputEditText UI Component found in Android Material Design.
 https://material.io/guidelines/components/text-fields.html#text-fields-field-types
 */
IB_DESIGNABLE
@interface KSOTextInputEditTextField : KDITextField

/**
 Set and get the floating label text.
 */
@property (copy,nonatomic,nullable) IBInspectable NSString *label;

/**
 Set and get the primary color for the component. This is the color used for after the TextField has had text applied.
 
 The default is UIColor.blackColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *primaryColor UI_APPEARANCE_SELECTOR;

/**
 Set and get the secondary color for the component. This is the color used for before the TextField has had text applied.
 
 The default is UIColor.grayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *secondaryColor UI_APPEARANCE_SELECTOR;

/**
 Set and get the accent color for the component. This is the color used for when the TextField is selected for text input.
 This property replaces the tint color of its parent class. Likewise, setting the tint color on this class will update the accent color here.
 
 The default is the default tint color.
 */
@property (strong,nonatomic,null_resettable) UIColor *accentColor UI_APPEARANCE_SELECTOR;

/**
 Set and get the disabled color for the component. This is the color used for when the TextField is disabled.
 
 The default is UIColor.lightGrayColor.
 */
@property (strong,nonatomic,null_resettable) UIColor *disabledColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END

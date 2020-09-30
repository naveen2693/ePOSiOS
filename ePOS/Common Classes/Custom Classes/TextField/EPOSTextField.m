//
//  EPOSTextField.m
//  ePOS
//
//  Created by Matra Sharma on 09/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

#import "EPOSTextField.h"
#import "ePOS-Swift.h"

#import "MaterialTextControlsPrivate+OutlinedStyle.h"

@interface EPOSTextField (Private) <MDCTextControl>
@end

@interface EPOSTextField ()
@end

@implementation EPOSTextField

#pragma mark Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonMDCOutlinedTextFieldInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonMDCOutlinedTextFieldInit];
    }
    return self;
}

- (void)commonMDCOutlinedTextFieldInit {
    self.containerStyle = [[MDCTextControlStyleOutlined alloc] init];
    
    [self setOutlineColor:[UIColor textBoxBorderColor] forState:MDCTextControlStateNormal];
    [self setOutlineColor:[UIColor darkThemeColor] forState:MDCTextControlStateEditing];
    [self setFloatingLabelColor:[UIColor darkThemeColor] forState:MDCTextControlStateEditing];
    [self setFloatingLabelColor:[UIColor titleColor] forState:MDCTextControlStateNormal];
    [self setTrailingAssistiveLabelColor:[UIColor redTextColor] forState:MDCTextControlStateNormal]  ;
    [self setTrailingAssistiveLabelColor:[UIColor redTextColor] forState:MDCTextControlStateEditing]  ;
    self.label.font = [UIFont regularFontWithSize:12];
    self.font = [UIFont regularFontWithSize:15];
    self.textColor = [UIColor textColor];
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    UIView* paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2,  self.frame.size.height)];
    paddingView.backgroundColor = UIColor.clearColor;
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}

#pragma mark Stateful Color APIs

- (void)setOutlineColor:(nonnull UIColor *)outlineColor forState:(MDCTextControlState)state {
    [self.outlinedStyle setOutlineColor:outlineColor forState:state];
    [self setNeedsLayout];
}

- (nonnull UIColor *)outlineColorForState:(MDCTextControlState)state {
    return [self.outlinedStyle outlineColorForState:state];
}

#pragma mark Private Helpers

- (MDCTextControlStyleOutlined *)outlinedStyle {
    MDCTextControlStyleOutlined *outlinedStyle = nil;
    if ([self.containerStyle isKindOfClass:[MDCTextControlStyleOutlined class]]) {
        outlinedStyle = (MDCTextControlStyleOutlined *)self.containerStyle;
    }
    return outlinedStyle;
}

@end

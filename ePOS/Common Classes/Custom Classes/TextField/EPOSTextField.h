//
//  EPOSTextField.h
//  ePOS
//
//  Created by Matra Sharma on 09/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

#import "MDCOutlinedTextField.h"


@interface EPOSTextField : MDCBaseTextField

- (void)setOutlineColor:(nonnull UIColor *)outlineColor forState:(MDCTextControlState)state;

- (nonnull UIColor *)outlineColorForState:(MDCTextControlState)state;

@end


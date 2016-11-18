//
//  LYUITextField.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/10.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYTextFieldDelegate <NSObject>



@optional
- (void)LYTextFieldDeleteBackward:(UITextField *)textField;
@end

@interface LYUITextField : UITextField

@property (nonatomic, assign) id <LYTextFieldDelegate> LY_delegate;
@property(nonatomic) NSInteger Sections;
@end

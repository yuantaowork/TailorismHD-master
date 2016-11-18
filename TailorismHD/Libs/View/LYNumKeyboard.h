//
//  LYNumKeyboard.h
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/29.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYNumKeyboard : NSObject

+(NSString *)keyBoardtag:(NSInteger)tag;


+(UITextField *)inputContentRestriction:(UITextField *)textfield btntag:(NSInteger)btntag;


@end

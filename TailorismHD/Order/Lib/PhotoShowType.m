//
//  PhotoShowType.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/9/6.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "PhotoShowType.h"

@implementation PhotoShowType
+(NSArray *)photoShowType:(NSString *)typeStr {
    
    NSArray * arry = nil ;

    if ([typeStr isEqualToString:@"领型"]) {
        
        arry = @[@"标准领.jpg",@"八字领.jpg",@"一字领.jpg",@"领尖扣领.jpg",@"小方领.jpg",@"圆领.jpg",@"礼服领.jpg",@"立领.jpg",@"暗扣领.jpg"];
        
    }else if ([typeStr isEqualToString:@"袖型"]) {
        
        arry = @[@"单扣.jpg",@"双扣.jpg",@"法式.jpg"];
        
    }else if ([typeStr isEqualToString:@"门襟"]) {
        
        arry = @[@"明门襟.jpg",@"平门襟.jpg",@"暗门襟.jpg"];
        
    }else if ([typeStr isEqualToString:@"活插片"]) {
        
        arry = @[@"活插片.jpg"];
        
    }



    return arry;

}
@end

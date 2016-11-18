//
//  TabsButton.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/26.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "TabsButton.h"

@implementation TabsButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (_parameterLab==nil) {
        
        _parameterLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame)-25, CGRectGetWidth(self.frame), 20)];

    }
    _parameterLab.textAlignment = NSTextAlignmentCenter;
//    _parameterLab.text = @"123123";
    [self addSubview:_parameterLab];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}


@end

//
//  MemberInfoController.h
//  TailorismHD
//
//  Created by LIZhenNing on 16/9/5.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "ViewController.h"

@interface MemberInfoController : ViewController

@property (strong,nonatomic)NSDictionary  * memberDataDic;
@property (strong,nonatomic)NSString * pushID; //用于判断是哪个入口进来的。 1代表 修改客户信息 2.代表 下单。3.代表添加新客户。
@property (strong,nonatomic)NSDictionary * imagedic;

@end

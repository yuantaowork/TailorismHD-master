//
//  PaddingDataController.h
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/25.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface PaddingDataController : UIViewController


@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) UIPopoverController *popoverController;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@property (nonatomic, strong) NSDictionary   *memberDic;
@property (strong,nonatomic ) NSDictionary   *imagedic;
@property (nonatomic,strong)  NSString * pushID;

@end

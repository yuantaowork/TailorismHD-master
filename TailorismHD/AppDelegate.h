//
//  AppDelegate.h
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)forceUpVersion;

-(void)getrootViewController;
- (UIViewController *)getCurrentVC;
- (UIViewController *)getPresentedViewController;
-(void)getHttpMeberList;

@end


//
//  AppDelegate.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/23.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#define PGY_APPKEY @"fa6cd9288595171c77d3611d8c4f90c7"

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic , strong)NSDictionary *updateDic;

@end

@implementation AppDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSURL *url = [NSURL URLWithString:[self.updateDic objectForKey:@"appUrl"]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)updateMethodWithDictionary:(NSDictionary *)dic {
    
    self.updateDic = dic;
    [self forceUpVersion];
}

- (void)forceUpVersion {
    double localVersion =[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] doubleValue];
    if (localVersion < (double)[[self.updateDic objectForKey:@"versionName"] doubleValue]) {
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:[self.updateDic objectForKey:@"releaseNote"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [self.window addSubview:alertV];
        [alertV show];
        return;
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    //    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    //    `强制更新
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethodWithDictionary:)];
    [[PgyManager sharedPgyManager] setThemeColor:[UIColor colorWithHex:@"37C5A1"]];
    [[PgyManager sharedPgyManager] setShakingThreshold:4.0];
    
    
    [SVProgressHUD  setBackgroundColor:[UIColor colorWithHex:@"6d87c3" alpha:.9]];
    [SVProgressHUD  setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    
    [self getrootViewController];
    
    return YES;
    
}


- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations =
//    (1 << UIInterfaceOrientationPortrait);
     (1 << UIInterfaceOrientationLandscapeLeft)
    | (1 << UIInterfaceOrientationLandscapeRight);
    //| (1 << UIInterfaceOrientationPortraitUpsideDown);

    
    return supportedInterfaceOrientations;
}

-(void)getrootViewController
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        
        NSLog(@"第一次启动");
        
        
        
    }else{
        NSLog(@"不是第一次启动");
        
        
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Token"]!=nil)
    {
        
        UIStoryboard * storeyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController =[storeyboard instantiateInitialViewController];
        
    }else
    {
        LoginController * loginView = [[LoginController alloc]init];
        
        self.window.rootViewController = loginView;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



//获取当前屏幕显示的viewcontroller
- (id )getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}




- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}


-(void)getHttpMeberList
{
    
    NSDictionary * dic = @{@"token":[[NSUserDefaults standardUserDefaults]valueForKey:@"Token"],@"pageSize":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:MerberList parameters:dic progress:Nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            if ([[responseObject objectForKey:@"data"]count]==0) {
                return ;
            }
            
            if ([LYFmdbTool insertMember:[[responseObject objectForKey:@"data"]objectForKey:@"data"]del:NO appdelegate:YES] ) {

            }
            
            NSMutableArray * dataarry = [[NSMutableArray alloc]init];
            for (int i =0; i<[[[responseObject objectForKey:@"data"]objectForKey:@"data"]count]; i++)
            {
                
                
                NSDictionary * dic = [[[responseObject objectForKey:@"data"]objectForKey:@"data"]objectAtIndex:i];
                
                if (![[dic objectForKey:@"phone_number"]isEqual:[NSNull null]])
                {
                    if (![[dic objectForKey:@"name"]isEqual:[NSNull null]])
                    {
                        [dataarry addObject:@{@"name":[dic objectForKey:@"name"],@"phone_number":[dic objectForKey:@"phone_number"],@"consignee_address":[dic objectForKey:@"consignee_address"]}];
                    }
                    
                }
                
            }
            
        }else
        {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);

    }];
}


@end

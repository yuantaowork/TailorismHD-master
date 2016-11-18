//
//  PersonalController.h
//  TailorismHD
//
//  Created by LIZhenNing on 16/8/24.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HTTPSuccess)(BOOL httpSuccess);

@interface PersonalController : UIViewController

-(void)getHttpMeberList:(NSString *)pagestr success:(void(^)(BOOL Success))httpSuccess;

@end

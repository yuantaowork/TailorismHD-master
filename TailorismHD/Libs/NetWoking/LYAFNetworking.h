//
//  LYAFNetworking.h
//  TailorismMall
//
//  Created by LIZhenNing on 16/8/12.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@interface LYAFNetworking : NSObject

+(void)AFNetworking:( NSString*)url  parameters:(id)parameters  completionBlock:(void(^)(id responseData, NSError *error))completion;
@end

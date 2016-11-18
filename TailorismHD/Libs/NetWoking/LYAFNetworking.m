//
//  LYAFNetworking.m
//  TailorismMall
//
//  Created by LIZhenNing on 16/8/12.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "LYAFNetworking.h"

//#define HTTPUrl @"http://test.api.shliangyi.net/"
//#define imageHTTPUrl @"http://test.image.shliangyi.net/"

//#define imageHTTPUrl @"http://image.shliangyi.net/"
//#define HTTPUrl @"http://api.shliangyi.net/"


@implementation LYAFNetworking


+(void)AFNetworking:(NSString*)url
         parameters:(id)parameters
    completionBlock:(void(^)(id responseData, NSError *error))completion {

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSError * dicError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&dicError];

        
        if (!dicError) {
            
            completion(result,nil);
            
        }else {
            
            NSString *resultError = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            [SVProgressHUD showInfoWithStatus:resultError];
           
        }
 
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@",  error);
        
        if (completion) {
            completion(nil,error);
        }
        
    }];
    
}

@end

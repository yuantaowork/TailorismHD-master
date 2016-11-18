//
//  AlertTabelView.h
//  Tailorism
//
//  Created by LIZhenNing on 16/5/18.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^AlertStringBlock)(NSString *showText);

@protocol AlertTabelViewDelegate
-(void)alertTabel:(UITextField *)textFild text:(NSString *)text;

@end

@interface AlertTabelView : UIViewController

@property NSUInteger  tagid;
@property (nonatomic, copy) AlertStringBlock alertStringBlock;

-(void)setTagID:(NSInteger)tagID;

- (void)returnText:(AlertStringBlock)block;

@property(assign,nonatomic)id<AlertTabelViewDelegate> delegate;
@end

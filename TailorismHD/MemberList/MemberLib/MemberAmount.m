//
//  MemberAmount.m
//  TailorismHD
//
//  Created by LIZhenNing on 16/9/5.
//  Copyright © 2016年 LIZhenNing. All rights reserved.
//

#import "MemberAmount.h"
#import "MemberType.h"
@implementation MemberAmount

+(NSMutableArray*)memberAmount:(NSDictionary *)dic {
    
    NSMutableArray * dataarry = [[NSMutableArray alloc]init];
    
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"height"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"weight"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"collar_opening"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"chest_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"middle_waisted"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"swing_around"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"arm_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"left_wrist_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"right_wrist_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"should_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"left_sleeve"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"back_length"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"chest"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"back"]]];
    [dataarry addObject:[MemberType meberType:[MemberAmount Nallstring:[dic objectForKey:@"body_shape"]]type:@"body_shape"]];
    [dataarry addObject:[MemberType meberType:[MemberAmount Nallstring:[dic objectForKey:@"station_layout"]]type:@"station_layout"]];
    [dataarry addObject:[MemberType meberType:[MemberAmount Nallstring:[dic objectForKey:@"shoulder"]]type:@"shoulder"]];
    [dataarry addObject:[MemberType meberType:[MemberAmount Nallstring:[dic objectForKey:@"abdomen"]]type:@"abdomen"]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"note"]]];
    [dataarry addObject:@""];
    
    
    return dataarry;
}

+(NSMutableArray*)memberAmountZoom:(NSDictionary *)dic  {
    
     NSMutableArray * dataarry = [[NSMutableArray alloc]init];
    
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"processed_chest_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"processed_middle_waisted"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"processed_swing_around"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"processed_arm_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"processed_left_wrist_width"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"processed_right_wrist_width"]]];
    [dataarry addObject:@""];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"right_sleeve"]]];
    [dataarry addObject:[MemberAmount Nallstring:[dic objectForKey:@"front_length"]]];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    [dataarry addObject:@""];
    
     return dataarry;
}

+(NSString *)Nallstring:(id)str {
    
    
    if ([str isEqual:[NSNull null]])
    {
        return @"";
    }else if ([str isEqualToString:@"<null>"]) {
        
        return @"";
    }
    else if ([str isEqual:@"0.0"])
    {
        return @"";
    }else
    {
        return str;
    }
}

@end

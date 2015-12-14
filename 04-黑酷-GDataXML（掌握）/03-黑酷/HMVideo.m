//
//  HMVideo.m
//  03-黑酷
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMVideo.h"

@implementation HMVideo
+ (instancetype)videoWithDict:(NSDictionary *)dict
{
    HMVideo *video = [[self alloc] init];
    [video setValuesForKeysWithDictionary:dict];
    return video;
}
@end

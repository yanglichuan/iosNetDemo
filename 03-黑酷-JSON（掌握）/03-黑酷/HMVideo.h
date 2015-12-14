//
//  HMVideo.h
//  03-黑酷
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMVideo : NSObject
/**
 *  ID
 */
@property (nonatomic, assign) int id;
/**
 *  时长
 */
@property (nonatomic, assign) int length;

/**
 *  图片（视频截图）
 */
@property (nonatomic, copy) NSString *image;

/**
 *  视频名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  视频的播放路径
 */
@property (nonatomic, copy) NSString *url;

+ (instancetype)videoWithDict:(NSDictionary *)dict;
@end

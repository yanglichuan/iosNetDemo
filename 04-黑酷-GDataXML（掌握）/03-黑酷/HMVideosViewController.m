//
//  HMVideosViewController.m
//  03-黑酷
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMVideosViewController.h"
#import "MBProgressHUD+MJ.h"
#import "HMVideo.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GDataXMLNode.h"

#define HMUrl(path) [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8080/MJServer/%@", path]]

@interface HMVideosViewController ()
@property (nonatomic, strong) NSMutableArray *videos;
@end

@implementation HMVideosViewController

- (NSMutableArray *)videos
{
    if (!_videos) {
        self.videos = [[NSMutableArray alloc] init];
    }
    return _videos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     加载服务器最新的视频信息
     */
    
    // 1.创建URL
    NSURL *url = HMUrl(@"video?type=XML");
    
    // 2.创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError || data == nil) {
            [MBProgressHUD showError:@"网络繁忙，请稍后再试！"];
            return;
        }
        
        // 解析XML数据
        
        // 加载整个XML数据
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        
        // 获得文档的根元素 -- videos元素
        GDataXMLElement *root = doc.rootElement;
        
        // 获得根元素里面的所有video元素
        NSArray *elements = [root elementsForName:@"video"];
        
        // 遍历所有的video元素
        for (GDataXMLElement *videoElement in elements) {
            HMVideo *video = [[HMVideo alloc] init];
            
            // 取出元素的属性
            video.id = [videoElement attributeForName:@"id"].stringValue.intValue;
            video.length = [videoElement attributeForName:@"length"].stringValue.intValue;
            video.name = [videoElement attributeForName:@"name"].stringValue;
            video.image = [videoElement attributeForName:@"image"].stringValue;
            video.url = [videoElement attributeForName:@"url"].stringValue;
            
            // 添加到数组中
            [self.videos addObject:video];
        }
        
        // 刷新表格
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"video";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    HMVideo *video = self.videos[indexPath.row];
    
    cell.textLabel.text = video.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"时长 : %d 分钟", video.length];
    
    // 显示视频截图
    NSURL *url = HMUrl(video.image);
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placehoder"]];
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出对应的视频模型
    HMVideo *video = self.videos[indexPath.row];
    
    // 2.创建系统自带的视频播放控制器
    NSURL *url = HMUrl(video.url);
    MPMoviePlayerViewController *playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    // 3.显示播放器
    [self presentViewController:playerVc animated:YES completion:nil];
}
@end

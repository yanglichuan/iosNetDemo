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

@interface HMVideosViewController () <NSXMLParserDelegate>
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
        
        // 1.创建XML解析器 -- SAX -- 逐个元素往下解析
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        
        // 2.设置代理
        parser.delegate = self;
        
        // 3.开始解析（同步执行）
        [parser parse];
        
        // 4.刷新表格
        [self.tableView reloadData];
    }];
}

#pragma mark - NSXMLParser的代理方法
/**
 *  解析到文档的开头时会调用
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
//    NSLog(@"parserDidStartDocument----");
}

/**
 *  解析到一个元素的开始就会调用
 *
 *  @param elementName   元素名称
 *  @param attributeDict 属性字典
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([@"videos" isEqualToString:elementName]) return;
    
    HMVideo *video = [HMVideo videoWithDict:attributeDict];
    [self.videos addObject:video];
}

/**
 *  解析到一个元素的结束就会调用
 *
 *  @param elementName   元素名称
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"didEndElement----%@", elementName);
}

/**
 *  解析到文档的结尾时会调用（解析结束）
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    NSLog(@"parserDidEndDocument----");
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

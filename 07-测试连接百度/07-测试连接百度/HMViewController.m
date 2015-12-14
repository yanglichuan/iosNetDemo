//
//  HMViewController.m
//  07-测试连接百度
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.URL
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    // 2.请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    }];
}

@end

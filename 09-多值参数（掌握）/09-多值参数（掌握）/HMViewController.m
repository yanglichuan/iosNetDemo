//
//  HMViewController.m
//  09-多值参数（掌握）
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"
#import "MBProgressHUD+MJ.h"

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
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/MJServer/weather"];
    
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 3.请求方法
    request.HTTPMethod = @"POST";
    
    // 4.设置请求体（请求参数）
    NSMutableString *param = [NSMutableString string];
    [param appendString:@"place=beijing"];
    [param appendString:@"&place=tianjin"];
    [param appendString:@"&place=meizhou"];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    // 5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil || connectionError) return;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *error = dict[@"error"];
        if (error) {
            [MBProgressHUD showError:error];
        } else {
//            NSArray *weathers = dict[@"weathers"];
            NSLog(@"%@", dict);
        }
    }];
}

@end

//
//  HMViewController.m
//  01-基本的HTTP请求
//
//  Created by apple on 14-9-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"
#import "MBProgressHUD+MJ.h"

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)login;
@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)login {
    // 1.用户名
    NSString *usernameText = self.username.text;
    if (usernameText.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    
    // 2.密码
    NSString *pwdText = self.pwd.text;
    if (pwdText.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    // 3.发送用户名和密码给服务器(走HTTP协议)
    // 创建一个URL ： 请求路径
    NSString *urlStr = [NSString stringWithFormat:@"http://localhost:8080/MJServer/login?username=%@&pwd=%@",usernameText, pwdText];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSLog(@"begin---");
    
    // 发送一个同步请求(在主线程发送请求)
    // queue ：存放completionHandler这个任务
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // 这个block会在请求完毕的时候自动调用
        if (connectionError || data == nil) {
            [MBProgressHUD showError:@"请求失败"];
            return;
        }
        
        // 解析服务器返回的JSON数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *error = dict[@"error"];
        if (error) {
            // {"error":"用户名不存在"}
            // {"error":"密码不正确"}
            [MBProgressHUD showError:error];
        } else {
            // {"success":"登录成功"}
            NSString *success = dict[@"success"];
            [MBProgressHUD showSuccess:success];
        }
     }];
    
//    NSLog(@"end---");
}
@end

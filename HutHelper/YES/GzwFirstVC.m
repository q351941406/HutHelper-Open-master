//
//  GzwFirstVC.m
//  彩票
//
//  Created by mac on 2017/11/2.
//  Copyright © 2017年 彩票. All rights reserved.
//

#import "GzwFirstVC.h"

@interface GzwFirstVC ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation GzwFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:icon];
    self.image.layer.cornerRadius = 25;
    self.image.layer.masksToBounds = YES;
    self.image.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

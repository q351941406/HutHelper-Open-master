//
//  HandTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "Hand.h"
#import "User.h"
#import "AFNetworking.h"
#import "HandShowViewController.h"
#import <MJExtension/MJExtension.h>
@implementation HandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:nil options:nil]lastObject];
        
    }
    return self;
}
+(instancetype)tableviewcell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:nil options:nil]lastObject];
}
- (IBAction)Buuton1:(id)sender {
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录后查看" toView:self];
        return;
    }
    Hand *hand=_handArray[(short)(((UITableViewCell*)[[sender superview]superview]).tag+1)*2-1];
                 //进入商品界面
                 HandShowViewController *handShow=[[HandShowViewController alloc]init];
                 handShow.isSelfGoods=self.isSelfGoods;
                 handShow.handDic=hand.mj_keyValues;
                 AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [tempAppDelegate.mainNavigationController pushViewController:handShow animated:YES];

    
    
    
}
- (IBAction)Button2:(id)sender {

    Hand *hand=_handArray[(short)(((UITableViewCell*)[[sender superview]superview]).tag+1)*2];

    //进入商品界面
    HandShowViewController *handShow=[[HandShowViewController alloc]init];
    handShow.isSelfGoods=self.isSelfGoods;
    handShow.handDic=hand.mj_keyValues;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:handShow animated:YES];

}

- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}


@end

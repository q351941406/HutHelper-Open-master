//
//  MomentsAddViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/15.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsAddViewController.h"
#import "TZImagePickerController.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface MomentsAddViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *Img1;
@property (weak, nonatomic) IBOutlet UIImageView *Img2;
@property (weak, nonatomic) IBOutlet UIImageView *Img3;
@property (weak, nonatomic) IBOutlet UIImageView *Img4;
@property (weak, nonatomic) IBOutlet UITextView *Say_Text;
@property (nonatomic,copy) NSString      *responstring;
@property  int getphoto;
@end

@implementation MomentsAddViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title          = @"发表说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(postsay) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    _Say_Text.text = @"请输入发表内容...";
    _Say_Text.textColor = [UIColor lightGrayColor];
    _Say_Text.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Add:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        switch (_selectedPhotos.count) {
            case 1:
                _Img1.image=_selectedPhotos[0];
                break;
            case 2:
                _Img1.image=_selectedPhotos[0];
                _Img2.image=_selectedPhotos[1];
                break;
            case 3:
                _Img1.image=_selectedPhotos[0];
                _Img2.image=_selectedPhotos[1];
                _Img3.image=_selectedPhotos[2];
                break;
            default:
                _Img1.image=_selectedPhotos[0];
                _Img2.image=_selectedPhotos[1];
                _Img3.image=_selectedPhotos[2];
                _Img4.image=_selectedPhotos[3];
                break;
        }
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)postsay{
    NSString *Url_String=Config.getApiMomentsCreate;
     if([_Say_Text.text isEqual:@"请输入发表内容..."]||[_Say_Text.text isEqual:@""]){
        [MBProgressHUD showError:@"文本不能为空" toView:self.view];
    }
    [MBProgressHUD showMessage:@"发表中" toView:self.view];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"提交成功，审核通过合规后会展示"];
//        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入发表内容..."]) {
            textView.text=@"";
    }
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}

-(void)reload{
    [Config setNoSharedCache];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [APIRequest GET:[Config getApiMoments:1] parameters:nil success:^(id responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     HideAllHUD
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:@"网络错误" toView:self.view];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
             }             HideAllHUD
         }failure:^(NSError *error) {
             [MBProgressHUD showError:@"网络错误" toView:self.view];
             HideAllHUD
         }];
    
}


@end

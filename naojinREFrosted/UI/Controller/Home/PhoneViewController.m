//
//  PhoneViewController.m
//  zsqBook
//
//  Created by 黑曼巴 on 15-5-27.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import "PhoneViewController.h"
#import "MobClick.h"
#import "TalkingData.h"
#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/CountryAndAreaCode.h>
#import "YMGHomeViewController.h"
#import "REFrostedViewController.h"
#import "REFrostedNavigationController.h"
#import "UIViewController+REFrostedViewController.h"

@interface PhoneViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *PhoneText;
@property (nonatomic, strong) UITextField *CodeText;
@property (nonatomic, strong) UIButton *Submitbtn;
@property (nonatomic, strong) UIAlertView *successAlert;

@end

@implementation PhoneViewController

- (void)viewDidLoad
{
    [TalkingData trackEvent:@"更多：绑定手机"];
    [MobClick event:@"更多：绑定手机"];

    [super viewDidLoad];
    self.title = @"绑定手机";
    self.tableView.separatorStyle = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TalkingData trackPageBegin:@"绑定手机"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackPageEnd:@"绑定手机"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"绑定手机"];
    _PhoneText.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"phone"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"绑定手机"];
}

- (void)tapBackground
{
    [self.view endEditing:YES];
}

-(void)getCode
{
    [TalkingData trackEvent:@"绑定手机：获取验证码按钮"];
    [MobClick event:@"绑定手机：获取验证码按钮"];
    NSString *areaCode = @"86";
    NSString *rule1=@"^1(3|5|7|8|4)\\d{9}";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
    BOOL isMatch=[pred evaluateWithObject:_PhoneText.text];
    if (!isMatch||_PhoneText.text.length!=11)
    {
        [TalkingData trackEvent:@"绑定手机：获取验证码手机号码不正确"];
        [MobClick event:@"绑定手机：获取验证码手机号码不正确"];

        //手机号码不正确
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"请输入正确的手机号码", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [TalkingData trackEvent:@"绑定手机：获取验证码手机号码不正确" label:_PhoneText.text];
    [MobClick event:@"绑定手机：获取验证码手机号码不正确" label:_PhoneText.text];

    [SMS_SDK getVerificationCodeBySMSWithPhone:_PhoneText.text
                                          zone:areaCode
                                        result:^(SMS_SDKError *error)
     {
         if (error)
         {
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                           message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                 otherButtonTitles:nil, nil];
             [alert show];
         }else{
             __block int timeout=30; //倒计时时间
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
             dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
             dispatch_source_set_event_handler(_timer, ^{
                 if(timeout<=0){
                     dispatch_source_cancel(_timer);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [_Submitbtn setTitle:@"获取" forState:UIControlStateNormal];
                         _Submitbtn.userInteractionEnabled = YES;
                     });
                 }else{
                     int seconds = timeout % 60;
                     NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [_Submitbtn setTitle:[NSString stringWithFormat:@"%@秒后",strTime] forState:UIControlStateNormal];
                         _Submitbtn.userInteractionEnabled = NO;
                     });
                     timeout--;
                     
                 }
             });
             dispatch_resume(_timer);
         }
     }];
}

-(void)submitCode
{
    [TalkingData trackEvent:@"绑定手机：提交验证码"];
    [MobClick event:@"绑定手机：提交验证码"];

    if(_CodeText.text.length!=4)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"验证码不正确", nil) delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [SMS_SDK commitVerifyCode:_CodeText.text result:^(enum SMS_ResponseState state) {
            if (1 == state){
                [TalkingData trackEvent:@"绑定手机：手机号码验证成功"];
                [MobClick event:@"绑定手机：手机号码验证成功"];
                self.successAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号码注册成功", nil) message:@"温馨提示" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
                [self.successAlert show];
            }else if(0 == state){
                [TalkingData trackEvent:@"绑定手机：手机号码验证失败"];
                [MobClick event:@"绑定手机：手机号码验证失败"];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号码验证失败", nil) message:@"温馨提示" delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

-(void)deleteText
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    cell.backgroundColor = [UIColor colorWithWhite:255 alpha:0.3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = NO;
    if (indexPath.row == 0) {
        UILabel *Titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 40)];
        Titlelabel.textColor = [UIColor blueColor];
        Titlelabel.textAlignment = NSTextAlignmentCenter;
        Titlelabel.numberOfLines = 0;
        Titlelabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        Titlelabel.text = @"温馨提示：为了您的账户安全，\n请绑定手机号码并完善个人信息。";
        [cell addSubview:Titlelabel];
    }else if (indexPath.row ==1){
        _PhoneText = [[UITextField alloc] initWithFrame:CGRectMake(30, 10, (self.view.frame.size.width-60)/4*3, 30)];
        _PhoneText.borderStyle = UITextBorderStyleRoundedRect;
        _PhoneText.placeholder = @"请输入手机号码";
        [cell addSubview:_PhoneText];
        
        _Submitbtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_PhoneText.frame)+5, 10, (self.view.frame.size.width-80)/4, 30)];
        _Submitbtn.layer.cornerRadius = 5.0f;
        [_Submitbtn setBackgroundImage:[UIImage imageNamed:@"submitbtn.png"] forState:UIControlStateNormal];
        [_Submitbtn setBackgroundImage:[UIImage imageNamed:@"submitbtn_select.png"] forState:UIControlStateHighlighted];
        [_Submitbtn setTitle:@"获取" forState:UIControlStateNormal];
        [_Submitbtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_Submitbtn];
    }else if(indexPath.row == 2){
        _CodeText = [[UITextField alloc] initWithFrame:CGRectMake(30, 10, self.view.frame.size.width-60, 30)];
        _CodeText.borderStyle = UITextBorderStyleRoundedRect;
        _CodeText.placeholder = @"请输入验证码";
        [cell addSubview:_CodeText];
    }else if (indexPath.row ==3){
        UIButton *cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, (self.view.frame.size.width-60)/5*2, 30)];
        cancelbtn.layer.cornerRadius = 5.0f;
        [cancelbtn setBackgroundImage:[UIImage imageNamed:@"cancelbtn.png"] forState:UIControlStateNormal];
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cancelbtn];
        
        UIButton *okbtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelbtn.frame)+(self.view.frame.size.width-60)/5, 10, (self.view.frame.size.width-60)/5*2, 30)];
        okbtn.layer.cornerRadius = 5.0f;
        [okbtn setBackgroundImage:[UIImage imageNamed:@"submitbtn.png"] forState:UIControlStateNormal];
        [okbtn setBackgroundImage:[UIImage imageNamed:@"submitbtn_select.png"] forState:UIControlStateHighlighted];
        [okbtn setTitle:@"确定" forState:UIControlStateNormal];
        [okbtn addTarget:self action:@selector(submitCode) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:okbtn];
        
    }
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView == self.successAlert) {
        if (buttonIndex == 0) {
            YMGHomeViewController *homeViewController = [[YMGHomeViewController alloc] init];
            REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:homeViewController];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
        }
    }
}

@end

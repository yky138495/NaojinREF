//
//  HomeViewController.m
//  naojin
//
//  Created by yang mengge on 15/1/22.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import "HomeViewController.h"
#import "localSqlService.h"
#import "BannerViewController.h"
#import "TalkingData.h"

#define ARBUTTON_ITEM_FRAME CGRectMake(0.f, 0.f, 30.f, 30.f)

@interface HomeViewController ()<UITextViewDelegate>
//{
//    GDTMobBannerView *_bannerView;
//}

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) UITextView *textView;

@end

@implementation HomeViewController
//
//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:@"BannerView" bundle:nibBundleOrNil];
//    if (self) {
//        bannerView = [[GDTMobBannerView alloc]initWithFrame:CGRectMake(0, 0, GDTMOB_AD_SUGGEST_SIZE_320x50.width, GDTMOB_AD_SUGGEST_SIZE_320x50.height)
//                                                     appkey:@"1104322742" placementId:@"8000608136215839"];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    _bannerView = [[GDTMobBannerView alloc]initWithFrame:CGRectMake(0, 200, GDTMOB_AD_SUGGEST_SIZE_320x50.width, GDTMOB_AD_SUGGEST_SIZE_320x50.height)
                                                 appkey:@"100720253" placementId:@"9079537207574943610"];
    _bannerView.layer.borderColor = [UIColor redColor].CGColor;
    _bannerView.layer.borderWidth = 1.f;
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
*/
    
    self.title = @"脑筋急转弯";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:0 forKey:@"index"];
    
    NSArray * sqlarray = [[localSqlService sharedInstance]getAllData];
    self.array = [[NSMutableArray alloc]initWithArray:sqlarray];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一题" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一题" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClicked:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor blackColor]};
//    
//    self.navigationItem.leftBarButtonItem = [self leftBarButtonItem];
//    
//    self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
    
    
    self.textView = [self creataTextView];
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
}

- (void)dealloc
{
    _bannerView.delegate = nil;
    _bannerView.currentViewController = nil;
    _bannerView = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackPageEnd:self.title];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [TalkingData trackPageBegin:self.title];
    NSUserDefaults *userDefaule = [NSUserDefaults standardUserDefaults];
    NSUInteger index = [[userDefaule objectForKey:@"index"]integerValue];
    NSDictionary *dictionary = [self.array objectAtIndex:index];
    self.textView.text = [dictionary objectForKey:@"Q"];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    UIButton *BarBtn = [[UIButton alloc] init];
    BarBtn.frame = ARBUTTON_ITEM_FRAME;
    [BarBtn setTitle:@"上一个" forState:UIControlStateNormal];
    [BarBtn setTintColor:[UIColor blackColor]];
    [BarBtn addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * BarItem = [[UIBarButtonItem alloc] initWithCustomView:BarBtn];
    return BarItem;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    UIButton *BarBtn = [[UIButton alloc] init];
    BarBtn.frame = ARBUTTON_ITEM_FRAME;
    [BarBtn setTitle:@"下一个" forState:UIControlStateNormal];
    [BarBtn addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * BarItem = [[UIBarButtonItem alloc] initWithCustomView:BarBtn];
    return BarItem;
}

- (void)leftButtonClicked:(id)sender
{
    
   // [self showBannerView];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSUInteger index = [[userDefault objectForKey:@"index"] integerValue] - 1;
    if (index == 0 - 1) {
        index = [self.array count] - 1;
    }
    [userDefault setInteger:index forKey:@"index"];
    
    NSDictionary *dictionary = [self.array objectAtIndex:index];
    self.textView.text = [dictionary objectForKey:@"Q"];
}

-(void)showBannerView
{
    BannerViewController *banner = [[BannerViewController alloc] init];
    [self.navigationController pushViewController:banner animated:YES];
}

- (void)rightButtonClicked:(id)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUInteger index = [[userDefault objectForKey:@"index"] integerValue] + 1;
    if (index == [self.array count]) {
        index = 0;
    }
    [userDefault setInteger:index forKey:@"index"];
    
    NSDictionary *dictionary = [self.array objectAtIndex:index];
    self.textView.text = [dictionary objectForKey:@"Q"];
}

- (NSUInteger)randomIntegert
{
    NSUInteger randomData = floor(arc4random() % self.array.count);  //  0.0 to 1.0
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setInteger:randomData forKey:@"index"];
    [userDefault synchronize];
    
    return randomData;
}

- (UITextView *)creataTextView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height / 2.f;
    CGFloat offest = 0.f;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(offest, 100, width, height)];
    textView.font = [UIFont systemFontOfSize:30];
    textView.textAlignment = NSTextAlignmentCenter;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUInteger index = [[userDefault objectForKey:@"index"] integerValue];
    
    NSDictionary *dictionary = [self.array objectAtIndex:index];
    textView.text = [dictionary objectForKey:@"Q"];
    return textView;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerViewMemoryWarning
{
    NSLog(@"%s",__FUNCTION__);
}

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"%s",__FUNCTION__);
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(int)errCode
{
    NSLog(@"%s",__FUNCTION__);
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"%s",__FUNCTION__);
}

// banner条曝光回调
//
// 详解:banner条曝光时回调该方法
- (void)bannerViewWillExposure
{
    NSLog(@"%s",__FUNCTION__);
}

// banner条点击回调
//
// 详解:banner条被点击时回调该方法
- (void)bannerViewClicked
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)bannerViewWillClose
{
    NSLog(@"%s",__FUNCTION__);
}

@end
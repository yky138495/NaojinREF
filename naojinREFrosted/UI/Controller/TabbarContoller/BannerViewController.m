//
//  BannerViewController.m
//  GDTMobSample
//
//  Created by GaoChao on 13-11-1.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "BannerViewController.h"

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation BannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"BannerView" bundle:nibBundleOrNil];
    if (self) {
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 50,
                                                                        GDTMOB_AD_SUGGEST_SIZE_320x50.width,
                                                                        GDTMOB_AD_SUGGEST_SIZE_320x50.height)
                                                      appkey:@"100720253"
                                                 placementId:@"9079537207574943610"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_OS_7_OR_LATER) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    _bannerView.delegate = self; // 设置Delegate
    _bannerView.currentViewController = self; //设置当前的ViewController
    _bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
    _bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
    _bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
    _bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
    [self.view addSubview:_bannerView]; //添加到当前的view中
    [_bannerView loadAdAndShow]; //加载广告并展示
}

- (void) viewWillDisappear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)bannerViewMemoryWarning
{

}

- (void)bannerViewDidReceived
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)bannerViewFailToReceived:(int)errCode
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)bannerViewWillLeaveApplication
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)bannerViewWillExposure
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)bannerViewClicked
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)bannerViewWillClose
{
    NSLog(@"%s",__FUNCTION__);
}

@end

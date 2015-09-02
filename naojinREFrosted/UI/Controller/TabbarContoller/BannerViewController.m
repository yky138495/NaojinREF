//
//  BannerViewController.m
//  GDTMobSample
//
//  Created by GaoChao on 13-11-1.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//


#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#import "BannerViewController.h"

@implementation BannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"BannerView" bundle:nibBundleOrNil];
    if (self) {
        /*
         * 创建Banner广告View
         * "appkey" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
         * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
         * 
         * banner条广告，广点通提供如下3中尺寸供开发者使用
         * 320*50 适用于iPhone
         * 468*60、728*90适用于iPad
         * banner条的宽度开发者可以进行手动设置，用以满足开发场景需求或是适配最新版本的iphone
         * banner条的高度广点通侧强烈建议开发者采用推荐的高度，否则显示效果会有影响
         * 
         * 这里以320*50为例
         */
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
    /*
     * 如果是IOS7的系统，设置视图不延伸至导航栏所在区域。
     */
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
    NSLog(@"%s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__FUNCTION__);
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

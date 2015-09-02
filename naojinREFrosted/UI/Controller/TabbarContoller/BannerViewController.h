//
//  BannerViewController.h
//  GDTMobSample
//
//  Created by GaoChao on 13-11-1.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTMobBannerView.h" //导入GDTMobBannerView.h头文件


@interface BannerViewController : UIViewController<GDTMobBannerViewDelegate>
{
    GDTMobBannerView *_bannerView;//声明一个GDTMobBannerView的实例
}

@end

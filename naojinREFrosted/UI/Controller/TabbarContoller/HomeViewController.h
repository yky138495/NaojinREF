//
//  HomeViewController.h
//  naojin
//
//  Created by yang mengge on 15/1/22.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import "YMGViewController.h"
#import "GDTMobBannerView.h" //导入GDTMobBannerView.h头文件

@interface HomeViewController : YMGViewController<GDTMobBannerViewDelegate>
{
    GDTMobBannerView *_bannerView;//声明一个GDTMobBannerView的实例
}

@end

//
//  UMHandleViewController_New.m
//  UMUFPDemo
//
//  Created by liuyu on 10/10/13.
//  Copyright (c) 2013 Realcent. All rights reserved.
//

#import "UMHandleViewController_New.h"
#import <QuartzCore/QuartzCore.h>

@interface UMHandleViewController_New ()

@end

@implementation UMHandleViewController_New

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    badgeView = nil;
    handleView.delegate = nil;
    handleView = nil;
}

- (void)showContentView
{
    if (handleView){
        [handleView showHandleViewDetailPage];
        badgeView.hidden = YES;
    }
}

- (void)setupSelfDefinedEntrance
{
    UIButton *entranceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    entranceBtn.frame = CGRectMake(10, 300, 100, 37);
    entranceBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [entranceBtn setTitle:@"精彩推荐" forState:UIControlStateNormal];
    [entranceBtn addTarget:self action:@selector(showContentView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:entranceBtn];
    badgeView = [[UMUFPBadgeView alloc] initWithFrame:CGRectMake(entranceBtn.bounds.size.width-18, -3, 22, 22)];
    badgeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [entranceBtn addSubview:badgeView];
    badgeView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"推广墙";
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageview.image = [UIImage imageNamed:@"placeholder.png"];
    [self.view insertSubview:imageview atIndex:0];
    
    handleView = [[UMUFPHandleView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-88, 32, 88) appKey:nil slotId:@"54730" currentViewController:self];
    handleView.delegate = (id<UMUFPHandleViewDelegate>)self;
    [self setupSelfDefinedEntrance];
    [handleView requestPromoterDataInBackground];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - UMUFPHandleView delegate methods

// 取广告列表数据完成

- (void)didLoadDataFinished:(UMUFPHandleView *)_handleView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [badgeView updateNewMessageCount:_handleView.mNewPromoterCount];
}

// 取广告数据失败

- (void)didLoadDataFailWithError:(UMUFPHandleView *)handleView error:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 小把手被点击，广告将被展示

- (void)didClickHandleView:(UMUFPHandleView *)handleView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 该方法在 手动调用 showHandleViewDetailPage 方法，但关联的资源尚未加载完成或加载失败时 被触发

- (void)failedToOpenContentView:(UMUFPHandleView *)handleView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 关闭按钮被点击，广告将被收起

- (void)handleViewDidPackUp:(UMUFPHandleView *)_handleView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 相关的广告被点击

- (void)didClickedPromoterAtIndex:(UMUFPHandleView *)handleView index:(NSInteger)promoterIndex promoterData:(NSDictionary *)promoterData
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

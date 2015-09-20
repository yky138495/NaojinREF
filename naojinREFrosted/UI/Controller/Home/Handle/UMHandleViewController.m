//
//  UMHandleViewController.m
//  UFP
//
//  Created by liu yu on 8/1/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMHandleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UMUFPBadgeView.h"

@interface UMHandleViewController ()

@end

@implementation UMHandleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc {
    
    handleView.delegate = nil;
    handleView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"推广墙";
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageview.image = [UIImage imageNamed:@"placeholder.png"];
    [self.view insertSubview:imageview atIndex:0];
    handleView = [[UMUFPHandleView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, 44, 44) appKey:nil slotId:@"54730" currentViewController:self];
    handleView.delegate = (id<UMUFPHandleViewDelegate>)self;
    handleView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    handleView.mBadgeView.frame = CGRectMake(handleView.bounds.size.width-16, -8, 22, 22);
    [self.view addSubview:handleView];
    [handleView requestPromoterDataInBackground];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
}

// 取广告数据失败，小把手将不会出现
- (void)didLoadDataFailWithError:(UMUFPHandleView *)handleView error:(NSError *)error
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 小把手被点击，广告将被展示
- (void)didClickHandleView:(UMUFPHandleView *)handleView {
    
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

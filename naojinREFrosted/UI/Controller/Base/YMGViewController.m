//
//  YMGBaseViewController.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/7.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "YMGViewController.h"
#import "REFrostedNavigationController.h"
#import "TalkingData.h"
#import "MobClick.h"

@interface YMGViewController ()

@end

@implementation YMGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TalkingData trackPageBegin:self.title];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackPageEnd:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

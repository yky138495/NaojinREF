//
//  YMGTableViewController.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/7.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "YMGTableViewController.h"
#import "REFrostedNavigationController.h"
#import "TalkingData.h"
#import "MobClick.h"

@interface YMGTableViewController ()

@end

@implementation YMGTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    UIColor * tableViewBackgroundColor;
    tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                               green:113.0/255.0
                                                blue:115.0/255.0
                                               alpha:1.0];
    [self.tableView setBackgroundColor:tableViewBackgroundColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
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

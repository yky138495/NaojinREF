//
//  YMGTabbarController.m
//  naojin
//
//  Created by yang mengge on 15/1/22.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import "YMGTabbarController.h"
#import "RDVTabBarItem.h"
#import "HomeViewController.h"
#import "AnswerViewController.h"
#import "CatalogTableViewController.h"
#import "TalkingData.h"

@interface YMGTabbarController()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) RDVTabBarController *tabBarController;

@end

@implementation YMGTabbarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViewControllers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [TalkingData trackPageBegin:@"Tab创建"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [TalkingData trackPageEnd:@"Tab消失"];
}

- (void)setupViewControllers {
    
    UIViewController *firstViewController = [[HomeViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[AnswerViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[CatalogTableViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    self.tabBarController = [[RDVTabBarController alloc] init];
    [self.tabBarController setViewControllers:@[firstNavigationController,              secondNavigationController,
                                                thirdNavigationController]];
    self.viewController = self.tabBarController;
    [self customizeTabBarForController:self.tabBarController];
}


- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third",@"second"];
    NSArray *titleArray = @[@"题目",@"答案",@"目录",@"设置"];
    NSArray *badgeArray = @[@"1",@"2",@"3",@"4"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setTitle:[titleArray objectAtIndex:index]];
        [item setBadgeValue:[badgeArray objectAtIndex:index]];
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}


@end

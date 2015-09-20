//
//  YMGHomeViewController.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/7.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "YMGHomeViewController.h"
#import "REFrostedNavigationController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "HomeViewController.h"
#import "AnswerViewController.h"
#import "CatalogTableViewController.h"
#import "TalkingData.h"

@interface YMGHomeViewController ()

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) RDVTabBarController *tabbarController;

@end

@implementation YMGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主页";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(REFrostedNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    [self setupViewControllers];
    if (self.tabbarController) {
        [self addChildViewController:self.tabbarController];
        [self.view addSubview:self.tabbarController.view];
        [self.tabbarController didMoveToParentViewController:self];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"DataUpdateNotification" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)updateData
{
    [self.tabbarController setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    self.tabbarController = [[RDVTabBarController alloc] init];
    [self.tabbarController setViewControllers:@[
                                                firstNavigationController,
                                                secondNavigationController,
                                                thirdNavigationController
                                                ]
     ];
    self.viewController = self.tabbarController;
    [self customizeTabBarForController:self.tabbarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    NSArray *titleArray = @[@"题目",@"答案",@"目录"];
    //NSArray *badgeArray = @[@"0",@"0",@"0"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setTitle:[titleArray objectAtIndex:index]];
        //[item setBadgeValue:[badgeArray objectAtIndex:index]];
        
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

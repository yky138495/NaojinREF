//
//  REFrostedNavigationController.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/7.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "REFrostedNavigationController.h"
#import "YMGMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface REFrostedNavigationController ()

@property (strong, readwrite, nonatomic)  YMGMenuViewController *menuViewController;

@end

@implementation REFrostedNavigationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Title style

- (void)commonInit
{
    self.navigationBar.translucent = NO;
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSFontAttributeName: [UIFont systemFontOfSize:16]};
    [self.navigationBar setTitleTextAttributes:textAttributes];
    self.navigationBar.barTintColor = [UIColor colorWithRed:123.f/255.f green:223.f/255.f blue:183.f/255.f alpha:0.9f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}


- (void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

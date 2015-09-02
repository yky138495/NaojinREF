
//
//  YMGMEnuDirectionViewController.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/10.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "YMGMEnuDirectionViewController.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "YMGHomeViewController.h"
#import "REFrostedNavigationController.h"

NSString * const ApplicationMenuDirectionChangedNotification = @"ApplicationMenuDirectionChangedNotification";

@interface YMGMEnuDirectionViewController ()

@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation YMGMEnuDirectionViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"更好风格";
    self.titleArray = @[@"左",@"右",@"上",@"下"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    NSUInteger row = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    cell.textLabel.text = [self.titleArray objectAtIndex:row];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20.f;
    }
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"menuDerection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationMenuDirectionChangedNotification
                                                        object:nil];
    
    YMGHomeViewController *homeViewController = [[YMGHomeViewController alloc] init];
    REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:homeViewController];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];

    
}

@end

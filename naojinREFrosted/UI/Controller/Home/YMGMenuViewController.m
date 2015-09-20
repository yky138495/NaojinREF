//
//  YMGMenuViewController.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/7.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "YMGMenuViewController.h"
#import "YMGHomeViewController.h"
#import "REFrostedNavigationController.h"
#import "PhoneViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "YMGMEnuDirectionViewController.h"
#import "UMFeedback.h"
#import "TalkingData.h"
#import "MobClick.h"
#import "UMHandleViewController.h"
#import "UMHandleViewController_New.h"

@interface YMGMenuViewController ()

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) UISwitch *switchBtn;

@end

@implementation YMGMenuViewController

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
    self.title = @"菜单";
    self.titleArray = @[
                        @[@"注册",@"主页",@"风格设置",@"随机出题",@"关于我们"],
                        @[@"意见反馈",@"支持一下",@"购物时刻"]
                        ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleArray objectAtIndex:section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    cell.textLabel.text = [[self.titleArray objectAtIndex:section]objectAtIndex:row];
    if (indexPath.section == 0 && indexPath.row == 3) {
        CGFloat leftPoint = self.view.frame.size.width - 70.f;
        UISwitch *switchButton = [[UISwitch alloc]init];
        switchButton.frame = CGRectMake(leftPoint, 5, 70, 35);
        [cell.contentView addSubview:switchButton];
    }
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40.f;
    }
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 25.f;
    }
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        PhoneViewController *phoneViewController = [[PhoneViewController alloc] init];
        REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:phoneViewController];
        self.frostedViewController.contentViewController = navigationController;
        [TalkingData trackEvent:@"注册点击"];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        YMGHomeViewController *homeViewController = [[YMGHomeViewController alloc] init];
        REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
        [TalkingData trackEvent:@"主页点击"];
        [MobClick event:@"naojinREF01"];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        YMGMEnuDirectionViewController *secondViewController = [[YMGMEnuDirectionViewController alloc] init];
        REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
        [TalkingData trackEvent:@"更换风格点击"];
        [MobClick event:@"naojinREF02"];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        YMGMEnuDirectionViewController *secondViewController = [[YMGMEnuDirectionViewController alloc] init];
        REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
        [TalkingData trackEvent:@"更换风格点击"];
    }else if (indexPath.section == 0 && indexPath.row == 4) {
        NSString *string = [NSString stringWithFormat:@"\n\t梦青文学是文学作品的开发团队，共同致力于文学书籍类APP的开发，为广大热爱文学的有识之士提供最充分的资源。如果有什么反馈意见，以上是联系方式。衷心地感谢您的支持和鼓励。\nQQ：3099009708\n Email：3099009708@qq.com\n"];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"梦青文学" message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [TalkingData trackEvent:@"关于点击"];
        [MobClick event:@"naojinREF03"];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        [self presentModalViewController:[UMFeedback feedbackModalViewController]
                                animated:YES];
        [TalkingData trackEvent:@"反馈点击"];
        [MobClick event:@"naojinREF04"];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/artist/mengge-yang/id982897015"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        [TalkingData trackEvent:@"软件推荐点击"];
        [MobClick event:@"naojinREF05"];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        [self showHandleView_New];
    }
    [self.frostedViewController hideMenuViewController];
}

- (void)showHandleView
{
    UMHandleViewController *controller = [[UMHandleViewController alloc] init];
    REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:controller];
    self.frostedViewController.contentViewController = navigationController;
}

- (void)showHandleView_New
{
    UMHandleViewController_New *controller = [[UMHandleViewController_New alloc] init];
    REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc] initWithRootViewController:controller];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

@end

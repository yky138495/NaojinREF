//
//  AppDelegate.m
//  naojinREFrosted
//
//  Created by yang mengge on 15/8/7.
//  Copyright (c) 2015年 yang mengge. All rights reserved.
//

#import "AppDelegate.h"
#import "YMGHomeViewController.h"
#import "YMGMenuViewController.h"
#import "REFrostedNavigationController.h"
#import "YMGMEnuDirectionViewController.h"
#import "UMFeedback.h"
#import "UMOpus.h"
//#import "MMUSDK.h"
#import "TalkingData.h"
#import "MobClick.h"
#import "UMessage.h"
#import <SMS_SDK/SMS_SDK.h>
#import <Bugly/CrashReporter.h>

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@property (nonatomic, assign) REFrostedViewControllerDirection frostedMenuDerection;
@property (nonatomic, strong) REFrostedViewController *frostedViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    REFrostedNavigationController *navigationController = [[REFrostedNavigationController alloc]initWithRootViewController:[YMGHomeViewController new]];
    YMGMenuViewController *menuViewController = [[YMGMenuViewController alloc]initWithStyle:UITableViewStylePlain];

    [self initThreePary];
    [self initUMengMessage:launchOptions];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"menuDerection"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    self.frostedViewController = [[REFrostedViewController alloc]initWithContentViewController:navigationController menuViewController:menuViewController];
    [self initMenuDirection];
    _frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    _frostedViewController.liveBlur = YES;
    _frostedViewController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initMenuDirection)
                                                 name:ApplicationMenuDirectionChangedNotification
                                               object:nil];
    self.window.rootViewController = _frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initMenuDirection
{
    NSInteger menuDirction = [[[NSUserDefaults standardUserDefaults]objectForKey:@"menuDerection"]integerValue];
    switch (menuDirction) {
        case 0:
            self.frostedMenuDerection = REFrostedViewControllerDirectionLeft;
            break;
        case 1:
            self.frostedMenuDerection = REFrostedViewControllerDirectionRight;
            break;
        case 2:
            self.frostedMenuDerection = REFrostedViewControllerDirectionTop;
            break;
        case 3:
            self.frostedMenuDerection = REFrostedViewControllerDirectionBottom;
            break;
            
        default:
            self.frostedMenuDerection = REFrostedViewControllerDirectionLeft;
            break;
    }
    _frostedViewController.direction = self.frostedMenuDerection;
}

- (void)initThreePary
{
    [self initFeedBack];
    [self initTaobaoSDk];
    [self initTalkingdata];
    [self initUMengTrack];
    [self initSms];
    [self initBugly];
}

- (void)initFeedBack
{
    [UMOpus setAudioEnable:YES];
    [UMFeedback setAppkey:@"55cdb9f6e0f55a1aa0001fe6"];
    [UMFeedback setLogEnabled:NO];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
}

- (void)initTalkingdata
{
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:@"C2744920A5BC63F6718E102232FB0A18" withChannelId:@"AppStore"];
}

- (void)initUMengTrack
{
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:@"55cdb9f6e0f55a1aa0001fe6" reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note
{
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)initUMengMessage:(NSDictionary *)launchOptions
{
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
    {
        [UMFeedback didReceiveRemoteNotification:notificationDict];
        // 自定义UI时需判断notificationDict[@"feedback"]
    }
    [UMessage startWithAppkey:@"55cdb9f6e0f55a1aa0001fe6" launchOptions:launchOptions];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkFinished:)
                                                 name:UMFBCheckFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
}

- (void)initSms
{
    //初始化应用，appKey和appSecret从后台申请得到
    [SMS_SDK registerApp:@"9b44023b199c"
              withSecret:@"6f20bf2bd948b67862da0eb851489623"];
    [SMS_SDK enableAppContactFriends:NO];
}

- (void)initBugly
{
#if DEBUG == 1
    [[CrashReporter sharedInstance] enableLog:YES];
#endif
    
    [[CrashReporter sharedInstance] installWithAppId:@"900007374"];
}

- (void)initTaobaoSDk
{
    //[MMUSDK sharedInstance].delegate = (id<MMUSDKDelegate>)self; //设置delegate
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    NSLog(@"deviceToken%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)receiveNotification:(id)receiveNotification {
    //    NSLog(@"receiveNotification = %@", receiveNotification);
}

- (void)checkFinished:(NSNotification *)notification {
    NSLog(@"class checkFinished = %@", notification);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}

#pragma mark -
#pragma mark - MMUSDKDelegate methods

/**
 
 @return 是否响应来自SDK的分享请求，响应时：返回YES；不响应时：返回NO
 
 */

- (BOOL)shouldHandleShareRequestFromSDK
{
    return NO;
}

/**
 
 用于处理来自SDK的分享请求
 
 @param  titleToShare 本次分享的标题
 @param  contentToShare 本次分享的文本内容
 @param  urlToShare 本次分享对应的url
 @param  imageToShare 需要分享的图片信息
 @param  controller 需哟使用分享功能的页面
 
 */

- (void)handleShareRequestWithTitle:(NSString *)titleToShare
                            content:(NSString *)contentToShare
                                url:(NSURL *)urlToShare
                              image:(UIImage *)imageToShare
                 withViewController:(UIViewController *)controller
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //在此处完成分享，并通过 [[MMUSDK sharedInstance] handleShareResult:shareType result:1]; 将对应的结果同步给SDK
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"new feedback", nil)])
    {
        if (buttonIndex == 1) // "open" button
        {
            UINavigationController *currentVC = (UINavigationController *)self.window.rootViewController;
            [currentVC pushViewController:[UMFeedback feedbackViewController]
                                 animated:YES];
        }
    }
}

@end

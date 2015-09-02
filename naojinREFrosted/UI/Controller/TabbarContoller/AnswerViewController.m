
//
//  AnswerViewController.m
//  naojin
//
//  Created by yang mengge on 15/1/22.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import "AnswerViewController.h"
#import "localSqlService.h"
#import "TalkingData.h"

@interface AnswerViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,assign) NSUInteger flag;

@property (nonatomic,strong) UIView *mask_view;

@property (nonatomic,strong) UILabel *countDownLable;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答案";
    self.flag = 5;
    NSArray * sqlarray = [[localSqlService sharedInstance]getAllData];
    self.array = [[NSMutableArray alloc]initWithArray:sqlarray];
    
    self.textView = [self creataTextView];
    self.textView.delegate = self;
   
    
    [self.view addSubview:self.textView];
    
    // Do any additional setup after loading the view.
}

- (void) layoutSubviews
{
    self.countDownLable.text = [NSString stringWithFormat:@"%ld",(long)self.flag];

}

- (void)showCountDownTime
{
    if (self.mask_view) {
        [self.mask_view  removeFromSuperview];
    }
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
    }else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeBegin:) userInfo:nil repeats:YES];
        self.flag = 5;
        [self.view addSubview:[self createMaskView]];
    }
    //[self.timer fire];
   
}

- (UIView *)createMaskView
{
    self.mask_view = [UIView new];
    self.mask_view.backgroundColor = [UIColor grayColor];
    self.mask_view.frame = self.view.frame;
    
    UILabel *infoLable = [UILabel new];
    infoLable.frame = CGRectMake(20, 50, 250, 90);
    infoLable.font = [UIFont systemFontOfSize:20];
    infoLable.text = @"答案即将揭晓 ......";
    [self.mask_view addSubview:infoLable];
    
    
    self.countDownLable = [[UILabel alloc]init];
    self.countDownLable.frame = self.view.frame;
    self.countDownLable.textAlignment = NSTextAlignmentCenter;
    self.countDownLable.text = [NSString stringWithFormat:@"%ld",(long)self.flag];
    self.countDownLable.font = [UIFont systemFontOfSize:80];
    [self.mask_view addSubview:self.countDownLable];
    return self.mask_view;
}

- (void)timeBegin:(id)sender
{
    self.flag--;
    self.countDownLable.text = [NSString stringWithFormat:@"%ld",(long)self.flag];
    
    if (self.flag == 0) {
        [AnswerViewController animateOut:self.mask_view bView:self.mask_view];
        
        [self.timer invalidate];
    }

}

+ (void)animateOut:(UIView *)theView bView:(UIView*)bview
{
    [UIView animateWithDuration:0.5 animations:^{
        theView.transform = CGAffineTransformMakeScale(1, 0.005);
    } completion:^(BOOL finished){
        //黑屏2s
        UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.center = bview.center;
        
        [bview addSubview:view];
        
        [UIView animateWithDuration:0.31 animations:^{
            theView.transform = CGAffineTransformMakeScale(0, 0);
            view.transform = CGAffineTransformMakeScale(1, 0.0000001);
            [UIView animateWithDuration:10 animations:^{
            }];
            //退出
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [theView removeFromSuperview];
                
            });
        }];
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self showCountDownTime];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUInteger index = [[userDefault objectForKey:@"index"] integerValue];
    NSDictionary *dictionary = [self.array objectAtIndex:index];
    self.textView.text = [dictionary objectForKey:@"A"];

}

- (UITextView *)creataTextView
{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height / 2.f;
    CGFloat offest = 0.f;
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(offest, 100, width, height)];
    textView.font = [UIFont systemFontOfSize:30];
    textView.textAlignment = NSTextAlignmentCenter;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUInteger index = [[userDefault objectForKey:@"index"] integerValue];
    NSDictionary *dictionary = [self.array objectAtIndex:index];
    textView.text = [dictionary objectForKey:@"A"];
    return textView;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  PopViewController.m
//  JianShuPopViewDemo
//
//  Created by LinGrea on 16/2/2.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "PopViewController.h"
#import "UIViewController+PopAnimated.h"

#define kContent_Height   (CGRectGetHeight(self.view.frame))
#define kContent_Width    (CGRectGetWidth(self.view.frame))

@implementation PopViewController
- (void)popWithAnimated:(UIViewController*)superVC
{
    //---必须强引用，否则会被释放，自定义dismiss的转场无效
    superVC.transition = [[LHCustomModalTransition alloc]initWithModalViewController:self];
    superVC.transition.dragable = YES;//---是否可下拉收起
    self.transitioningDelegate = superVC.transition;
    //---必须添加这句.自定义转场动画
    self.modalPresentationStyle = UIModalPresentationCustom;
    if(!self.backView)
    {
        self.backView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.backView.backgroundColor    = [UIColor blackColor];
        self.backView.tag       = 10000;
        self.backView.alpha     = 1;
        UIView* view    = [self.view.subviews objectAtIndex:[self.view.subviews count] - 1];
        [self.view addSubview:self.backView];
        [self.view bringSubviewToFront:view];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [self.view addGestureRecognizer:tap];
}

- (void)tap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  ModalViewController.h
//  JianShuPopViewDemo
//
//  Created by LinGrea on 16/2/2.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PopViewController : UIViewController
@property (nonatomic, strong) UIView*   backView;
- (void)popWithAnimated:(UIViewController*)superVC;
- (void)tap;
@end

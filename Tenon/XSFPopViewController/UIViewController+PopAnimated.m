//
//  Pop.m
//  JianShuPopViewDemo
//
//  Created by 吴友鹏 on 16/5/27.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "UIViewController+PopAnimated.h"
#import <objc/runtime.h>
@implementation UIViewController(PopViewAnimated)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static char *PersonNameKey = "transition";
-(void)setTransition:(LHCustomModalTransition *)transition{
    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, PersonNameKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(LHCustomModalTransition *)transition{
    return objc_getAssociatedObject(self, PersonNameKey);
}


@end

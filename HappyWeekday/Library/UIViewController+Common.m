//
//  UIViewController+Common.m
//  HappyWeekday
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)
//导航栏添加返回按钮
- (void)showBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}
- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

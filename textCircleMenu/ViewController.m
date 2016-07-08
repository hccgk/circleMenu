//
//  ViewController.m
//  textCircleMenu
//
//  Created by 川何 on 16/7/1.
//  Copyright © 2016年 川何. All rights reserved.
//

#import "ViewController.h"
#import "circleMenuManager.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@implementation ViewController

- (void)viewDidLoad
{
    UIView *cv = [circleMenuManager sharedInstance].bcView;
    [[circleMenuManager sharedInstance] initWithCircle:CGPointMake(kScreenW/2.0, kScreenH/2.0) circleR:150 buttonR:30 buttonNum:8];
    [self.view addSubview:cv];
    [self.view setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

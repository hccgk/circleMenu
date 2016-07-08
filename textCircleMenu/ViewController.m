//
//  ViewController.m
//  textCircleMenu
//
//  Created by 川何 on 16/7/1.
//  Copyright © 2016年 川何. All rights reserved.
//

#import "ViewController.h"
#import "circleMenuManager.h"


@implementation ViewController

- (void)viewDidLoad
{
    UIView *cv = [circleMenuManager sharedInstance].mainView;
    [self.view addSubview:cv];
    [self.view setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

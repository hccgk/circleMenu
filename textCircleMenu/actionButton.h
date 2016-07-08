//
//  actionButton.h
//  textCircleMenu
//
//  Created by 川何 on 16/7/1.
//  Copyright © 2016年 川何. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  buttonMakeTheCircleMove <NSObject>

-(void)degreedtoMove:(CGPoint )location and:(CGPoint)prevLocation;

-(void)touchedEndFast;
@end

@interface actionButton : UIButton

@property (nonatomic)id<buttonMakeTheCircleMove>delegate;

@end

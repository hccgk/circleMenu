//
//  circleBackgrandView.h
//  textCircleMenu
//
//  Created by 川何 on 16/7/8.
//  Copyright © 2016年 川何. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  backViewmakeCircleMove <NSObject>

-(void)degreedtoMove:(CGPoint )location and:(CGPoint)prevLocation;

-(void)touchedEndFast;
@end

@interface circleBackgrandView : UIView
@property (nonatomic)id<backViewmakeCircleMove>delegate;

@end

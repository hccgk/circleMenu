//
//  circleBackgrandView.m
//  textCircleMenu
//
//  Created by 川何 on 16/7/8.
//  Copyright © 2016年 川何. All rights reserved.
//

#import "circleBackgrandView.h"

@implementation circleBackgrandView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    CGPoint prevLocation = [touch previousLocationInView:self.superview];
    //调用代理方法,让主控制器进行控制操作
    [self.delegate degreedtoMove:location and:prevLocation];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.delegate touchedEndFast];
    
}

@end

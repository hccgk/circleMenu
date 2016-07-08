//
//  circleMenuManager.m
//  textCircleMenu
//
//  Created by 川何 on 16/7/8.
//  Copyright © 2016年 川何. All rights reserved.
//

#import "circleMenuManager.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface circleMenuManager()<buttonMakeTheCircleMove,backViewmakeCircleMove> {
//    UIView *mainView;
    
    actionButton* button;
    NSMutableArray* buttArr;
    NSInteger times;
    NSTimer* timer1;
    NSTimer *timerReduce;//抬手以后的延迟时间
    CGFloat startY;
    NSInteger buttonNumber;
    CGPoint circleHeart; // 圆心
    CGFloat butweent; //人工计算出来的角度平均值,也就是间距  button 之间的间隔弧度
    CGFloat circleR; //圆的半径
    CGFloat buttonR; //按钮的半径
    NSMutableArray *circleArr;//关于弧度的数组
    CGFloat olddegreed;  //olddegreed 为滑动的角度 记录上一次滑动的距离 . 还需要留着 停止滑动的时候这个最为其实的绘制角度来用
    NSMutableArray *degreedArrTwo;  //用一个数组记录最后2次的角度值

}

@end

@implementation circleMenuManager

+(circleMenuManager *)sharedInstance{
    static circleMenuManager *circlemenu;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        circlemenu = [[circleMenuManager alloc] init];
    });
    
    return circlemenu;
    
}
-(void)initWithCircle:(CGPoint)cHeart circleR:(CGFloat)cR buttonR:(CGFloat)butR buttonNum:(NSInteger)num{
    circleHeart = cHeart;
    circleR = cR;
    buttonR = butR;
    buttonNumber = num;
    [self makeupUI];

}

- (instancetype)init {
    
    _bcView = [[circleBackgrandView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _bcView.delegate = self;
//    circleR = kScreenH/2.0 - 180;
//    circleHeart = CGPointMake(kScreenW/2.0, kScreenH/2.0);
//    buttonR = 30;
    circleArr = [NSMutableArray array];
    degreedArrTwo = [NSMutableArray arrayWithCapacity:10];
    olddegreed = 0;
//    buttonNumber = 8;

    return self;
}


- (void)makeupUI
{
    // 1.创建多个按钮的数组,button 有tag 以方便后边查找 star位置 都在屏幕外边
    buttArr = [NSMutableArray array];
    
    for (int i = 0; i < buttonNumber; i++) {
        button = [[actionButton alloc]
                  initWithFrame:CGRectMake(0, kScreenH + buttonR * 2, buttonR * 2, buttonR * 2)];
        [button setBackgroundColor:[self RandomColor]];
        button.layer.cornerRadius = buttonR ;
        [button.layer masksToBounds];
        button.tag = 10000 + i + 1;
        [button setTitle:[NSString stringWithFormat:@"Menu%d",i+1 ]forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(clickButton:)
         forControlEvents:UIControlEventTouchUpInside];
        button.delegate = self;
        [buttArr addObject:button];
        
        [_bcView addSubview:button];
    }
    //按钮的间距
    butweent = M_PI * 2/ (buttArr.count);
    [self starMoved];
    
}




//按钮的代理方法
#pragma -mark delegate buttonMakeTheCircleMove
-(void)degreedtoMove:(CGPoint )location and:(CGPoint)prevLocation{
    
    [self makedegreed:location and:prevLocation];
    
    
}
-(void)touchedEndFast{
    CGFloat betweenNumber = [[degreedArrTwo lastObject] floatValue] -[[degreedArrTwo firstObject] floatValue];
    if (fabsf(betweenNumber)> 0.1) {
        //利用olddegreed 进行惯性动画
        [self reductionMoveing];
    }
}
//给2个点来判别滑动方向 和距离
-(void)makedegreed:(CGPoint )location and:(CGPoint)prevLocation{
    //根据角度来进行滑动,精细到每一次角度变化, 每次调用就不会重复叠加,视觉效果是和实际相同
    CGFloat degreed = 0;  //degreed 为滑动的角度
    //1.以开始点到圆心的距离为半径
    CGFloat moveR = [self distanceFromePoint:prevLocation Point2:circleHeart];
    //2.根据圆心,半径,和已知的2个点求得旋转角度,传递过去,让绘图部分进行绘图
    //问题:不是真实的角度
    degreed = asinf([self distanceFromePoint:location Point2:prevLocation] / 2.0 / moveR) * 2.0;
    
    //3.根据方向确定正负   //4.增加圆心左侧的判断 右侧是有区别的
//    if (circleHeart.x <location.x && circleHeart.x <prevLocation.x) {
//        if (location.y - prevLocation.y < -1) {
//            degreed = -degreed;
//        }
//        else if (location.y - prevLocation.y > 1) {
//            degreed = degreed;
//        }
//        else {
//            return;
//        }
//    }else if(circleHeart.x > location.x && circleHeart.x > prevLocation.x){
//        if (location.y - prevLocation.y < -1) {
//            degreed = degreed;
//        }
//        else if (location.y - prevLocation.y > 1) {
//            degreed = -degreed;
//        }
//        else {
//            return;
//        }
//    } else{
//        degreed = olddegreed;
//    }
//

    //TODO: 判断正负

    
    
    
    //4.普通加速判断处理  滑动的时候  2种加速一种在滑动的时候,一种是离开的时候
    if (olddegreed < degreed) {
        //加速处理函数 调用动画方法一定的时间  系数根据情况增加或者减少
        [self redrawed:degreed ];
        olddegreed = degreed; //记录上一次的角度
        return;
    }
    
    olddegreed = degreed; //记录上次的角度
    [self redrawed:degreed];
    
    
}
//滑动动画 ,调用次数比较频繁.所以不加运动路径,直接调整btn的center
- (void)redrawed:(CGFloat)degreed
{
    //往数组里面 以此添加degreed
    
    [degreedArrTwo addObject:@(degreed)];
    
    if (degreedArrTwo.count > 9) {
        [degreedArrTwo removeObjectAtIndex:0];
    }
    //    Olddegreend = degreed;
    for (int i = 0; i < buttArr.count; i++) {
        
        actionButton* btnNew = buttArr[i]; //获取的方式不是使用tag 是使用数组中的位置
        CGFloat startCircleArg = [circleArr[i] floatValue] ;
        

        
        
        
        
        
        CGFloat endX = sin(startCircleArg + degreed) * circleR + circleHeart.x;
        CGFloat endY = circleHeart.y - cos(startCircleArg + degreed) * circleR;

        [circleArr setObject:@(startCircleArg + degreed) atIndexedSubscript:i];
        
        
        btnNew.center = CGPointMake(endX, endY);
        [btnNew setNeedsDisplay];
    }
}
/**
 *
 1.多个球动画
 2.停止位置不同 需要4 来计算
 3.启动时间不一样[固定间隔]
 4.计算值(可以不用sin cos) 直接用个数进行平均分配一个π
 *
 *  @return 动画
 */
//开始动画
- (void)starMoved
{
    times = 0;
    
    [self setTimeuser];
}

- (void)setTimeuser
{
    timer1 = [NSTimer scheduledTimerWithTimeInterval:0.2
                                              target:self
                                            selector:@selector(movepoint:)
                                            userInfo:nil
                                             repeats:YES];
    //    [[NSRunLoop currentRunLoop]addTimer:timer1 forMode:NSRunLoopCommonModes];
    
}
//启动动画
- (void)movepoint:(NSTimer*)timer
{
    
    if (times == buttArr.count) {
        
        
        [timer1 invalidate];
        timer1 = nil;
        return;
    }
    actionButton* btn = (actionButton*)buttArr[times];
    //endarc
    CGFloat endarc = -M_PI_2 *3 + (times +1) * butweent;
    
    if (times +1 >0) {
        // 增加移动路径
        CGMutablePathRef path = CGPathCreateMutable();
        //动画路径
        CGPathAddArc(path, NULL, circleHeart.x, circleHeart.y, circleR,M_PI_2 *1.1,
                     endarc , YES);
        //按着移动路径移动
        CAKeyframeAnimation* animationbegain =
        [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animationbegain.delegate = self;
        animationbegain.path = path;
        [animationbegain setDuration:1.0]; //设定动画时间
        animationbegain.fillMode = kCAFillModeForwards;
        animationbegain.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [btn.layer addAnimation:animationbegain forKey:@"curve"];
        
    }

    [circleArr addObject:@(endarc +M_PI_2)];
    
    CGFloat centerX;
    CGFloat centerY;
    if (endarc < - M_PI) {//左下
        centerX = - sin(M_PI_2 *3 + endarc) * circleR + circleHeart.x;
        centerY =  cos(M_PI_2 *3 + endarc) * circleR +circleHeart.y;
    }else if (endarc < - M_PI_2){//左上
        centerX = - sin(-M_PI_2  - endarc) * circleR + circleHeart.x;
        centerY = - cos(-M_PI_2  - endarc) * circleR +circleHeart.y;
    }else if (endarc < 0){//右上
        centerX = sin(endarc + M_PI_2) * circleR + circleHeart.x;
        centerY = - cos(endarc + M_PI_2) * circleR +circleHeart.y;
    }else{//右下
        centerX = sin(M_PI_2 -endarc) * circleR +circleHeart.x;
        centerY = cos(M_PI_2 -endarc) * circleR +circleHeart.y;
    }
    
    btn.center = CGPointMake(centerX, centerY);
    
    times++;
    
}
//加速停止动画 间隔的角度一般 是 0.10 - 0.90 一般
-(void)reductionMoveing{
    //按时间 还是按角度递减?
    timerReduce = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(reduceMove) userInfo:nil repeats:YES];
    
}
-(void)reduceMove{
    if (olddegreed > 0) {
        if (olddegreed - 0.01 < 0.01) {
            
            [timerReduce invalidate];
            timerReduce = nil;
            return ;
        }
        
        olddegreed = olddegreed - 0.01 ;
        
    }else {
        if (olddegreed + 0.01 > -0.01) {
            
            [timerReduce invalidate];
            timerReduce = nil;
            return ;
        }
        
        olddegreed = olddegreed + 0.01 ;
    }
    
    
    [self redrawed:olddegreed];
    
}
//TODO: 写代理方法,让引用的控制器使用
#pragma - mark 点击按钮
- (void)clickButton:(actionButton*)btn
{
    
    
    
    switch (btn.tag - 10000) {
        case 1:
            NSLog(@"1 click");
            break;
        case 2:
            NSLog(@"2 click");
            break;
        case 3:
            NSLog(@"3 click");
            break;
        case 4:
            NSLog(@"4 click");
            break;
        case 5:
            NSLog(@"5 click");
            break;
        case 6:
            NSLog(@"6 click");
            break;
        case 7:
            NSLog(@"7 click");
            break;
        case 8:
            NSLog(@"8 click");
            break;
        case 9:
            NSLog(@"9 click");
            break;
        case 10:
            NSLog(@"10 click");
            break;
            
        default:
            break;
    }
}

- (void)animationDidStart:(CAAnimation*)anim
{
    //    NSLog(@"animationDidStart");
}
//停止动画
- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    //    NSLog(@"animationDidStop");
}

- (UIColor*)RandomColor
{
    CGFloat red = (arc4random() % 155) / 155.0;
    CGFloat green = (arc4random() % 255) / 255.0;
    CGFloat blue = (arc4random() % 155) / 155.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

//2点之间距离 NO! 不这样干 还是在角度启动之前做 带有正负也就是顺时针逆时针的方向

-(CGFloat)distanceFromePoint:(CGPoint)point1 Point2:(CGPoint)point2{
    
    CGFloat distance = 0;
    distance = sqrt((point1.x - point2.x )  * (point1.x - point2.x ) + (point1.y - point2.y ) * (point1.y - point2.y ));
    return distance;
}

@end

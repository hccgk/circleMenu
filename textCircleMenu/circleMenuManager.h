//
//  circleMenuManager.h
//  textCircleMenu
//
//  Created by 川何 on 16/7/8.
//  Copyright © 2016年 川何. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "actionButton.h"
#import "circleBackgrandView.h"


@interface circleMenuManager : NSObject
@property (nonatomic ,strong)circleBackgrandView *mainView;

+(circleMenuManager *)sharedInstance;

@end

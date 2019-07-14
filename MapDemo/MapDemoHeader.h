//
//  MapDemoHeader.h
//  MapDemo
//
//  Created by 徐洋 on 2019/7/14.
//  Copyright © 2019 徐洋. All rights reserved.
//

#ifndef MapDemoHeader_h
#define MapDemoHeader_h

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define FitFootHeight IOS11_OR_LATER_SPACE(MAIN_WINDOW.safeAreaInsets.bottom)

#define IOS11_OR_LATER_SPACE(par) \
({\
float space = 0.0;\
if (@available(iOS 11.0, *))\
space = par;\
(space);\
})

static const CGFloat RouteViewHeight = 140.f;

/*偏移量阈值*/
#define kOffsetThresholdLevelOne -(SCREEN_HEIGHT / 3.f) - STATUS_HEIGHT//一档  偏移量在屏幕的上三分之一
#define kOffsetThresholdLevelTwo -(SCREEN_HEIGHT / 3.f * 2) - STATUS_HEIGHT//二挡  偏移量在屏幕的中间的三分之一
//三挡  偏移量在屏幕的下三分之一 之所以没定义 是因为有了前两个直接用else就好了

/*偏移量*/
#define kOffsetLevelOne 0.f//一档  置顶
#define kOffsetLevelTwo  -(SCREEN_HEIGHT / 2.f - STATUS_HEIGHT)//二档  屏幕中间
#define kOffsetLevelThree -(SCREEN_HEIGHT - STATUS_HEIGHT - RouteViewHeight)//三档 置底 只保留头试图

#endif /* MapDemoHeader_h */

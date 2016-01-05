//
//  MainModel.h
//  HappyWeekday
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
  RecommendTypeActivity = 1,
    RecommendTypeTheme = 2
        
}RecommendType;

@interface MainModel : NSObject
//首页大图
@property(nonatomic, copy) NSString *image_big;
//标题
@property(nonatomic, copy) NSString *title;
//价格
@property(nonatomic, copy) NSString *price;
//经度
@property(nonatomic, assign) CGFloat lat;
//纬度
@property(nonatomic, assign) CGFloat lng;

@property(nonatomic, copy) NSString *address;

@property(nonatomic, copy) NSString *count;

@property(nonatomic, copy) NSString *startTime;

@property(nonatomic, copy) NSString *endTime;

@property(nonatomic, copy) NSString *activityId;

@property(nonatomic, copy) NSString *type;

@property(nonatomic, copy) NSString *activityDescription;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

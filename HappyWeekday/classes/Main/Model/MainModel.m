//
//  MainModel.m
//  HappyWeekday
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.type = dic[@"type"];
        if ([self.type integerValue] == 1) {
            self.price = dic[@"price"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
            self.address = dic[@"address"];
            self.count = dic[@"counts"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
        }else{
            self.activityDescription = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.activityId = dic[@"id"];
        
    }
    return self;
}

@end

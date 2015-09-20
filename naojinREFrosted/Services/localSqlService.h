//
//  localSqlService.h
//  naojin
//
//  Created by yang mengge on 15/2/6.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface localSqlService : NSObject

@property (nonatomic,strong) FMDatabase *database;

+ (instancetype)sharedInstance;
- (NSArray *)getAllData;
- (NSInteger)getDataBaseCount;

@end

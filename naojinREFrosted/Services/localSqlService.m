


//
//  localSqlService.m
//  naojin
//
//  Created by yang mengge on 15/2/6.
//  Copyright (c) 2015年 zhai shuqing. All rights reserved.
//

#import "localSqlService.h"

@implementation localSqlService

+ (instancetype)sharedInstance
{
    static localSqlService *_shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"naojin" withExtension:@"db3"];
        _shareClient = [[localSqlService alloc]initWithAddress:url.absoluteString];
    });
    return _shareClient;
}

- (instancetype)initWithAddress:(NSString *)address
{
    self = [super init];
    self.database = [FMDatabase databaseWithPath:address];
    [self.database open];
    return self;
}

- (void)dealloc
{
    if (self.database.open) {
        [self.database close];
    }
}

- (NSArray *)getAllData
{
    NSString *sql = @"select Question,Answer from naojin";
    FMResultSet *resultSet = [self.database executeQuery:sql];
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([resultSet next]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[resultSet objectForColumnIndex:0] forKey:@"Q"];
        [dictionary setObject:[resultSet objectForColumnIndex:1] forKey:@"A"];
        [resultArray addObject:dictionary];
    }
    return resultArray;
}

- (NSInteger)getDataBaseCount
{
    NSString *sql = @"select count(*) from naojin";
    NSInteger dbCount = 0;
    FMResultSet *resultSet = [self.database executeQuery:sql];
    dbCount = [[resultSet objectForColumnIndex:0] integerValue];
    return dbCount;
}

@end

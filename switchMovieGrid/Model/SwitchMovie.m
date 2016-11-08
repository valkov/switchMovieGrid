//
//  SwitchMovie.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchMovie.h"
#import "RLMObject+JSON.h"

@implementation SwitchMovie

+ (NSString *)primaryKey {
    return @"serverId";
}

#pragma mark - RLMObject+JSON


+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"id": @"serverId",
             @"poster_path" : @"posterPath"
             };
}

- (NSURL*)posterUrl {
    NSString *stringUrl = [POSTER_URL stringByAppendingPathComponent:self.posterPath];
    return [NSURL URLWithString:stringUrl];
}

@end

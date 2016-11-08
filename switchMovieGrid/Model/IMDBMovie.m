//
//  IMDBMovie.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "IMDBMovie.h"
#import "RLMObject+JSON.h"

@implementation IMDBMovie

+ (NSString *)primaryKey {
    return @"serverId";
}

#pragma mark - RLMObject+JSON

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{
             @"id": @"serverId",
             @"poster_path" : @"posterPath",
             @"backdrop_path" : @"backdropPath",
             @"title" : @"title",
             @"release_date" : @"releaseDate",
             @"vote_average" : @"score",
             @"overview" : @"overview"
             };
}

- (NSURL*)posterUrl {
    NSString *stringUrl = [POSTER_URL stringByAppendingPathComponent:self.posterPath];
    return [NSURL URLWithString:stringUrl];
}

- (NSURL*)backdropUrl {
    NSString *stringUrl = [POSTER_URL stringByAppendingPathComponent:self.backdropPath];
    return [NSURL URLWithString:stringUrl];
}

@end

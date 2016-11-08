//
//  IMDBMovieCatalog.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "IMDBMovieCatalog.h"
#import "RLMArray+LongestCommonSubsequence.h"
#import "RLMObject+Background.h"
#import "RLMObject+JSON.h"

#define kTotalPages @"total_pages"
#define kResults    @"results"

@implementation IMDBMovieCatalog

+ (NSString *)primaryKey {
    return @"name";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"remotePagesCount" : @0, @"pagesLoaded" : @0};
}

+ (IMDBMovieCatalog*)defaultCatalog {
    NSString *defaultName = @"DEFAULT_CATALOG";
    
    IMDBMovieCatalog *result = [IMDBMovieCatalog objectForPrimaryKey:defaultName];
    if(!result) {
        result = [IMDBMovieCatalog new];
        result.name = defaultName;
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:result];
        }];
    }
    return result;
}

- (void)applyResponseDictionaryOnBackground:(NSDictionary*)response pageNumber:(NSUInteger)pageNumber {
    BOOL removeExisting = pageNumber == 0;
    
    NSArray *results = response[kResults];
    
    [self transactionOnBackgroundWithBlock:^(IMDBMovieCatalog *backgroundSelf) {
        
        backgroundSelf.remotePagesCount = [response[kTotalPages] intValue];
        
        backgroundSelf.pagesLoaded = pageNumber == 0 ? 1 : backgroundSelf.pagesLoaded + 1;
        
        NSArray *newAndUpdated = [IMDBMovie createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONArray:results];
        
        NSIndexSet *addedIndexes, *removedIndexes;
        [backgroundSelf.movies indexesOfCommonElementsWithArray:newAndUpdated addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
        
        if(removeExisting) {
            //remove
            for (NSUInteger index = [removedIndexes lastIndex]; index != NSNotFound; index = [removedIndexes indexLessThanIndex:index]) {
                if (index >= backgroundSelf.movies.count) {
                    NSAssert(NO, @"can't be");
                }
                [backgroundSelf.movies removeObjectAtIndex:index];
            }
        }
        
        //insert
        [addedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            if(removeExisting)
                [backgroundSelf.movies insertObject:newAndUpdated[idx] atIndex:idx];
            else
                [backgroundSelf.movies addObject:newAndUpdated[idx]];
        }];
    }];
}

@end

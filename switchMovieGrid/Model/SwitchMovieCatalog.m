//
//  SwitchMovieCatalog.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchMovieCatalog.h"
#import "RLMArray+LongestCommonSubsequence.h"
#import "RLMObject+Background.h"
#import "RLMObject+JSON.h"

#define kTotalPages @"total_pages"
#define kResults    @"results"

@implementation SwitchMovieCatalog

+ (NSString *)primaryKey {
    return @"name";
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"remotePagesCount" : @0, @"pagesLoaded" : @0};
}

+ (SwitchMovieCatalog*)defaultCatalog {
    NSString *defaultName = @"DEFAULT_CATALOG";
    
    SwitchMovieCatalog *result = [SwitchMovieCatalog objectForPrimaryKey:defaultName];
    if(!result) {
        result = [SwitchMovieCatalog new];
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
    
    [self transactionOnBackgroundWithBlock:^(SwitchMovieCatalog *backgroundSelf) {
        
        backgroundSelf.remotePagesCount = [response[kTotalPages] intValue];
        
        backgroundSelf.pagesLoaded = pageNumber == 0 ? 1 : backgroundSelf.pagesLoaded + 1;
        
        NSArray *newAndUpdated = [SwitchMovie createOrUpdateInRealm:[RLMRealm defaultRealm] withJSONArray:results];
        
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

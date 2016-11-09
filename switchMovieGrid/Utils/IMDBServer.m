//
//  IMDBServer.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "IMDBServer.h"
#import <AFNetworking/AFNetworking.h>

@interface IMDBServer ()
@property (nonatomic, readonly) AFHTTPRequestOperationManager *operationsManager;
@end

#define kPage @"page"
#define kApiKey @"api_key"

@implementation IMDBServer

+ (instancetype)sharedServer {
    static IMDBServer *sManager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sManager = [[self alloc] init];
    });
    return sManager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _operationsManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:IMDB_HOST]];
        self.operationsManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (void)moviesListFromPage:(NSUInteger)pageNumber andCompletion:(apiCompletionBlock)completion {
    NSMutableDictionary *params = [@{kApiKey : API_KEY} mutableCopy];
    if(pageNumber > 0) {
        [params setObject:@(pageNumber) forKey:kPage];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.operationsManager GET:@"movie/now_playing" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(completion) {
            completion(nil, error);
        }
    }];

}
@end

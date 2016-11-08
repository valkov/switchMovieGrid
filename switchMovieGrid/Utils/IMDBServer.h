//
//  IMDBServer.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^apiCompletionBlock)(id response, NSError* error);
@interface IMDBServer : NSObject

+ (instancetype)sharedServer;

- (void)moviesListFromPage:(NSUInteger)pageNumber andCompletion:(apiCompletionBlock)completion;
@end

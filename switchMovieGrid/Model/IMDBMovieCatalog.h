//
//  IMDBMovieCatalog.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import <Realm/Realm.h>
#import "IMDBMovie.h"

@interface IMDBMovieCatalog : RLMObject
@property NSString *name;
@property int remotePagesCount;
@property int pagesLoaded;

@property (nonatomic, strong) RLMArray<IMDBMovie> *movies;

+ (IMDBMovieCatalog*)defaultCatalog;
- (void)applyResponseDictionaryOnBackground:(NSDictionary*)response pageNumber:(NSUInteger)pageNumber;
@end



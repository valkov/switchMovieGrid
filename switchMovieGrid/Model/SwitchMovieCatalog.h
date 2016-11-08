//
//  SwitchMovieCatalog.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import <Realm/Realm.h>
#import "SwitchMovie.h"

@interface SwitchMovieCatalog : RLMObject
@property NSString *name;
@property int remoteMoviesCount;

@property (nonatomic, strong) RLMArray<SwitchMovie> *movies;

+ (SwitchMovieCatalog*)defaultCatalog;
- (void)applyResponseDictionaryOnBackground:(NSDictionary*)response removeExisting:(BOOL)removeExisting;
@end



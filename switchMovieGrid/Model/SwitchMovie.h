//
//  SwitchMovie.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import <Realm/Realm.h>

@interface SwitchMovie : RLMObject
@property int serverId;
@property NSString *posterPath;

- (NSURL*)posterUrl;
@end

RLM_ARRAY_TYPE(SwitchMovie)

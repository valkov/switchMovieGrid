//
//  IMDBMovie.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import <Realm/Realm.h>

@interface IMDBMovie : RLMObject
@property int serverId;
@property NSString *posterPath;
@property NSString *backdropPath;
@property NSString *title;
@property NSString *releaseDate;
@property NSString *overview;
@property float score;


#warning no raiting info on server so in the model

- (NSURL*)posterUrl;
- (NSURL*)backdropUrl;
@end

RLM_ARRAY_TYPE(IMDBMovie)

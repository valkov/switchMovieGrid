//
//  Defines.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#define VIEW_HEIGHT ([UIScreen mainScreen].bounds.size.height + (([UIApplication sharedApplication].statusBarHidden) ? 0 : 20))
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width

#define DEBUG_SERVER 0

#define TILE_SEPARATOR_WIDTH 20
#define TILE_WIDTH VIEW_WIDTH / 2 - 30
#define TILE_HEIGHT VIEW_WIDTH / 1.5f

#define BACKGROUND_COLOR [UIColor colorWithRed:245.0f/255.0f green:247.0f/255.0f blue:253.0f/255.0f alpha:1.0f]

#define TITLE_COLOR [UIColor colorWithRed:138.0f/255.0f green:149.0f/255.0f blue:172.0f/255.0f alpha:1.0f]

#define IMDB_HOST @"http://api.themoviedb.org/3/"
#define API_KEY @"ebea8cfca72fdff8d2624ad7bbf78e4c"
#define POSTER_URL @"http://image.tmdb.org/t/p/w342"

#endif /* Defines_h */

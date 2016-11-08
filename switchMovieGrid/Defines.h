//
//  Defines.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#define VIEW_HEIGHT ([[UIScreen mainScreen] applicationFrame].size.height + (([UIApplication sharedApplication].statusBarHidden) ? 0:20))
#define VIEW_WIDTH [[UIScreen mainScreen] applicationFrame].size.width

#define DEBUG_SERVER 0

#define TILE_WIDTH VIEW_WIDTH / 3.0
#define TILE_HEIGHT VIEW_HEIGHT / 3.0

#define BACKGROUND_COLOR [UIColor colorWithRed:245.0f/255.0f green:247.0f/255.0f blue:253.0f/255.0f alpha:1.0f]

#define TITLE_COLOR [UIColor colorWithRed:138.0f/255.0f green:149.0f/255.0f blue:172.0f/255.0f alpha:1.0f]

#endif /* Defines_h */

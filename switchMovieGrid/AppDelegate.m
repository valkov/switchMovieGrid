//
//  AppDelegate.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "AppDelegate.h"
#import "SwitchMovieCollectionViewController.h"

@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    CGFloat const spacing = 1.0f;
    
    UICollectionViewFlowLayout *gridLayout = [[UICollectionViewFlowLayout alloc] init];
    gridLayout.minimumInteritemSpacing = spacing;
    gridLayout.minimumLineSpacing = spacing;
    gridLayout.itemSize = CGSizeMake(TILE_WIDTH - 1.0f, TILE_HEIGHT);
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SwitchMovieCollectionViewController alloc] initWithCollectionViewLayout:gridLayout]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    return YES;
}

@end

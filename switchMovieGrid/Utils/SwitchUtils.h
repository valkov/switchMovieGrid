//
//  SwitchUtils.h
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef void(^voidBlock)();

@interface SwitchUtils : NSObject

+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message;

+ (RACDisposable*)bindRLMObject:(RLMObject*)object arrayPropertyNamed:(NSString*)arrayPropertyName toSection:(NSUInteger)section ofCollectionView:(UICollectionView*)collectionView refreshBlock:(voidBlock)refreshBlock;
@end

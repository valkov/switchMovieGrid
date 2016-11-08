//
//  SwitchUtils.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchUtils.h"

@implementation SwitchUtils

+ (void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Reactive utils

+ (NSArray *)indexSetToIndexPathArray:(NSIndexSet *)indexes section:(NSInteger)section {
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:indexes.count];
    NSUInteger index = [indexes firstIndex];
    while (index != NSNotFound) {
        [paths addObject:[NSIndexPath indexPathForRow:index inSection:section]];
        index = [indexes indexGreaterThanIndex:index];
    }
    return paths;
}

+ (RACDisposable*)bindRLMObject:(RLMObject*)object arrayPropertyNamed:(NSString*)arrayPropertyName toSection:(NSUInteger)section ofCollectionView:(UICollectionView*)collectionView refreshBlock:(voidBlock)refreshBlock {
    
    RACSignal *signal = [object rac_valuesAndChangesForKeyPath:arrayPropertyName options:0 observer:nil];
    
    @weakify(collectionView);
    RACDisposable *result = [signal subscribeNext:^(RACTuple *info) { // tuple is value, change dictionary
                                     @strongify(collectionView);
                                     
                                     NSDictionary *change = info.second;
                                     NSKeyValueChange kind = [change[NSKeyValueChangeKindKey] intValue];
                                     NSIndexSet *indexes = change[NSKeyValueChangeIndexesKey];
                                     
                                     if (indexes) {
                                         NSArray *paths = [self indexSetToIndexPathArray:indexes section:section];
                                         if (kind == NSKeyValueChangeInsertion) {
                                             [collectionView performBatchUpdates:^{
                                                 [collectionView insertItemsAtIndexPaths:paths];
                                             } completion:^(BOOL finished) {
                                                 if(finished && refreshBlock)
                                                     refreshBlock();
                                             }];
                                         }
                                         else if (kind == NSKeyValueChangeRemoval) {
                                             [collectionView performBatchUpdates:^{
                                                 [collectionView deleteItemsAtIndexPaths:paths];
                                             } completion:^(BOOL finished) {
                                                 if(finished && refreshBlock)
                                                     refreshBlock();
                                             }];
                                         }
                                         else {
                                             [collectionView reloadData];
                                             if(refreshBlock)
                                                 refreshBlock();
                                         }
                                     }
                                     else {
                                         [collectionView reloadData];
                                         if(refreshBlock)
                                             refreshBlock();
                                     }
                                     
                                 }];
    return result;

}


@end

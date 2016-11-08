//
//  SwitchMovieCollectionViewController.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchMovieCollectionViewController.h"

@interface SwitchMovieCollectionViewController ()

@end

@implementation SwitchMovieCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Latest Movies", @"");
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = TITLE_COLOR;
    
    self.collectionView.backgroundColor = BACKGROUND_COLOR;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIImage *userImage = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(25, 25)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:userImage style:UIBarButtonItemStylePlain target:self action:@selector(openUserSettings)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark -

- (void)openUserSettings {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not implemented" message:@"This is not implemented" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

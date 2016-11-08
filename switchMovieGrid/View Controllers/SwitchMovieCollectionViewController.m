//
//  SwitchMovieCollectionViewController.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchMovieCollectionViewController.h"
#import "SwitchMovieCollectionViewCell.h"
#import "SVPullToRefresh.h"
#import "SwitchMovieCatalog.h"
#import "IMDBServer.h"
#import "RLMObject+Background.h"

@interface SwitchMovieCollectionViewController ()
@property (nonatomic, strong) SwitchMovieCatalog *movieCatalog;
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
    [self.collectionView registerClass:[SwitchMovieCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIImage *userImage = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(25, 25)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:userImage style:UIBarButtonItemStylePlain target:self action:@selector(openUserSettings)];
    
    @weakify(self);
    [self.collectionView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self refreshMoviesFromPage:0];
    }];
    
    [self.collectionView.pullToRefreshView setCustomView:[self customRefreshView] forState:SVPullToRefreshStateAll];
    
    self.movieCatalog = [SwitchMovieCatalog defaultCatalog];
    
    [SwitchUtils bindRLMObject:self.movieCatalog arrayPropertyNamed:@"movies" toSection:0 ofCollectionView:self.collectionView refreshBlock:^{
        NSLog(@"refreshed");
    }];
    
    if(![SwitchMovieCatalog defaultCatalog].movies.count) {
        [self refreshMoviesFromPage:0];
    }
}

- (UIView*)customRefreshView {
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 60)];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(refreshView.bounds.size.width/2 - 20, refreshView.bounds.size.height/2 - 20, 40, 40)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityView.color = TITLE_COLOR;
    [activityView startAnimating];
    [refreshView addSubview:activityView];
    
    return refreshView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [SwitchMovieCatalog defaultCatalog].movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SwitchMovieCollectionViewCell *cell = (SwitchMovieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.movie = [SwitchMovieCatalog defaultCatalog].movies[indexPath.item];
    
    return cell;
}

#pragma mark -

- (void)openUserSettings {

/*
 [[SwitchMovieCatalog defaultCatalog] transactionOnBackgroundWithBlock:^(SwitchMovieCatalog *defaultCatalog) {
        [defaultCatalog.movies removeAllObjects];
    }];
*/
    [SwitchUtils showAlertWithTitle:nil andMessage:@"Not implemented"];
}

- (void)refreshMoviesFromPage:(NSUInteger)pageNumber {
    [[IMDBServer sharedServer] moviesListFromPage:pageNumber andCompletion:^(id response, NSError *error) {
        if(pageNumber == 0)
            [self.collectionView.pullToRefreshView stopAnimating];
        
        if(!error) {
            [[SwitchMovieCatalog defaultCatalog] applyResponseDictionaryOnBackground:response removeExisting:YES];
        }
        else {
            [SwitchUtils showAlertWithTitle:NSLocalizedString(@"Error", @"") andMessage:error.localizedDescription];
        }
    }];

}

#pragma mark - Enable CollectionView bounce
- (void)edgeInsetsToFit {
    UIEdgeInsets edgeInsets = self.collectionView.contentInset;
    CGSize contentSize = self.collectionView.contentSize;
    CGSize size = self.collectionView.bounds.size;
    CGFloat heightOffset = (contentSize.height + edgeInsets.top) - size.height;
    if (heightOffset < 0) {
        edgeInsets.bottom = size.height - (contentSize.height + edgeInsets.top) + 1;
        self.collectionView.contentInset = edgeInsets;
    } else {
        edgeInsets.bottom = 0;
        self.collectionView.contentInset = edgeInsets;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self edgeInsetsToFit];
    });
}

#pragma mark -
- (void)dealloc {
    
}
@end

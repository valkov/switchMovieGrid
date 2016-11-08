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
#import "IMDBMovieCatalog.h"
#import "IMDBServer.h"
#import "SwitchMovieDetailsViewController.h"

@interface SwitchMovieCollectionViewController ()
@property (nonatomic, strong) IMDBMovieCatalog *movieCatalog;
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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIImage *userImage = [UIImage imageWithIcon:@"fa-user" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(25, 25)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:userImage style:UIBarButtonItemStylePlain target:self action:@selector(openUserSettings)];
    
    @weakify(self);
    [self.collectionView addPullToRefreshWithActionHandler:^{
        @strongify(self);
        [self refreshMoviesFromPage:0];
    }];
    
    [self.collectionView.pullToRefreshView setCustomView:[self customRefreshView] forState:SVPullToRefreshStateAll];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        [self refreshMoviesFromPage:self.movieCatalog.pagesLoaded + 1];
    }];
    
    self.movieCatalog = [IMDBMovieCatalog defaultCatalog];
    
    [SwitchUtils bindRLMObject:self.movieCatalog arrayPropertyNamed:@"movies" toSection:0 ofCollectionView:self.collectionView refreshBlock:^{
        @strongify(self);
        self.collectionView.showsInfiniteScrolling = self.movieCatalog.remotePagesCount > self.movieCatalog.pagesLoaded;
    }];
    
    if(![IMDBMovieCatalog defaultCatalog].movies.count) {
        [self.collectionView triggerPullToRefresh];
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
    return [IMDBMovieCatalog defaultCatalog].movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SwitchMovieCollectionViewCell *cell = (SwitchMovieCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.movie = [IMDBMovieCatalog defaultCatalog].movies[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SwitchMovieDetailsViewController *details = [SwitchMovieDetailsViewController new];
    details.movie = [IMDBMovieCatalog defaultCatalog].movies[indexPath.item];
    [self.navigationController pushViewController:details animated:YES];
}

#pragma mark - Private stuff

- (void)openUserSettings {
    [SwitchUtils showAlertWithTitle:nil andMessage:@"Not implemented"];
}

- (void)refreshMoviesFromPage:(NSUInteger)pageNumber {
    [[IMDBServer sharedServer] moviesListFromPage:pageNumber andCompletion:^(id response, NSError *error) {
        if(pageNumber == 0) {
            [self.collectionView.pullToRefreshView stopAnimating];
        }
        else {
            [self.collectionView.infiniteScrollingView stopAnimating];
        }
        
        if(!error) {
            [[IMDBMovieCatalog defaultCatalog] applyResponseDictionaryOnBackground:response pageNumber:pageNumber];
        }
        else {
            [SwitchUtils showAlertWithTitle:NSLocalizedString(@"Error", @"") andMessage:error.localizedDescription];
        }
    }];

}

#pragma mark -
- (void)dealloc {
    
}
@end

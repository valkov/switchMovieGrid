//
//  SwitchMovieDetailsViewController.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchMovieDetailsViewController.h"
#import "UIImageView+WebCache.h"

@interface SwitchMovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;

@end

@implementation SwitchMovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.movie.title;
    
    [self.backgroundImageView sd_setImageWithURL:self.movie.backdropUrl];
    
    self.posterImageView.clipsToBounds = YES;
    
    @weakify(self);
    [self.posterImageView sd_setImageWithURL:self.movie.posterUrl placeholderImage:[UIImage imageWithIcon:@"fa-refresh" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(25, 25)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        if(!error) {
            self.posterImageView.contentMode = UIViewContentModeScaleToFill;
        }
        else {
            self.posterImageView.image = [UIImage imageWithIcon:@"fa-exclamation" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(50, 50)];
            self.posterImageView.contentMode = UIViewContentModeCenter;
        }

    }];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.backgroundImageView addSubview:blurEffectView];
    } else {
        self.view.backgroundColor = [UIColor blackColor];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f", self.movie.score];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:self.movie.releaseDate];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.releaseDateLabel.text = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:date];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie.title, year];
    
    self.detailsTextView.text = self.movie.overview;
}

@end

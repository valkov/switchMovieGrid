//
//  SwitchMovieCollectionViewCell.m
//  switchMovieGrid
//
//  Created by Valentyn Kovalsky on 11/8/16.
//  Copyright © 2016 Valentyn Kovalsky. All rights reserved.
//

#import "SwitchMovieCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface SwitchMovieCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SwitchMovieCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = 6.0f;
        self.clipsToBounds = YES;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.image = [UIImage imageWithIcon:@"fa-refresh" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(25, 25)];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setMovie:(IMDBMovie *)movie {
    _movie = movie;
    
    if(self.movie.posterPath.length) {
        @weakify(self);
        [self.imageView sd_setImageWithURL:self.movie.posterUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if(!error) {
                self.imageView.contentMode = UIViewContentModeScaleToFill;
            }
        }];
    }
    else {
        self.imageView.image = [UIImage imageWithIcon:@"fa-exclamation" backgroundColor:[UIColor clearColor] iconColor:TITLE_COLOR andSize:CGSizeMake(50, 50)];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
}

@end

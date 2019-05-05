//
//  SCFilmstripView.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/5/5.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCFilmstripView.h"
#import "SCNotifications.h"
#import "SCThumbnail.h"
#import "SCDisplayerView.h"

@interface SCFilmstripView ()
@property (strong, nonatomic) NSArray *thumbnails;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SCFilmstripView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(buildScrubber:)
                                                     name:SCThumbnailsGeneratedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)buildScrubber:(NSNotification *)notification {
    
    self.thumbnails = [notification object];
    
    CGFloat currentX = 0.0f;
    
    CGSize size = [(UIImage *)[[self.thumbnails firstObject] image] size];
    CGSize imageSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(0.5, 0.5));
    CGRect imageRect = CGRectMake(currentX, 0, imageSize.width, imageSize.height);
    
    CGFloat imageWidth = CGRectGetWidth(imageRect) * self.thumbnails.count;
    self.scrollView.contentSize = CGSizeMake(imageWidth, imageRect.size.height);
    
    for (NSUInteger i = 0; i < self.thumbnails.count; ++i) {
        SCThumbnail *timedImage = self.thumbnails[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        [button setBackgroundImage:timedImage.image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(currentX, 0, imageSize.width, imageSize.height);
        button.tag = i;
        [self.scrollView addSubview:button];
        currentX += imageSize.width;
    }
}

- (void)imageButtonTapped:(UIButton *)sender {
    SCThumbnail *thumbnail = self.thumbnails[sender.tag];
    if (thumbnail) {
        if ([self.superview respondsToSelector:@selector(setCurrentTime:)]) {
            [(SCDisplayerView*)self.superview setCurrentTime:CMTimeGetSeconds(thumbnail.time)];
        }
    }
}

@end

//
//  SCPlayerView.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCPlayerView.h"
#import "SCDisplayerView.h"

@interface SCPlayerView ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) SCDisplayerView *operatedView;
@end

@implementation SCPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer*)player {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.playerLayer setPlayer:player];
        
        self.operatedView = [SCDisplayerView operatedView];
        [self addSubview:_operatedView];
    }
    return self;
}

+ (instancetype)playerViewWithPlayer:(AVPlayer*)player {
    return [[self alloc] initWithPlayer:player];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.operatedView.frame = self.frame;
}

#pragma mark - setter/getter
- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer*)self.layer;
}

- (id<SCVideoDisplayer>)displayer {
    return self.operatedView;
}

@end

//
//  SCPlayerController.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCPlayerController.h"
#import "SCPlayerView.h"
#import "SCDisplayerView.h"

#define kPlayerStatusKeyPath @"status"
#define kReftesfInterval 0.5f
static const NSString *PlayerItemStatusContext;

@interface SCPlayerController ()  <SCVideoDisplayerDelegate>
@property (nonatomic, strong) SCPlayerView *playerView;

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, weak) id<SCVideoDisplayer> displayer;

@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) id itemEndObserver;

@property (nonatomic, assign) float lastPlaybackRate;

@end

@implementation SCPlayerController

- (instancetype)initWithURL:(NSURL*)assetURL {
    if (self = [super init]) {
        _asset = [AVAsset assetWithURL:assetURL];
        [self prepareToPlay];
        
        // FIXME: - test
        [self.player play];
    }
    return self;
}

+ (instancetype)playerWithURL:(NSURL*)assetURL {
    return [[self alloc] initWithURL:assetURL] ;
}

- (void)dealloc {
    if (self.itemEndObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.itemEndObserver
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.player.currentItem];
        self.itemEndObserver = nil;
    }
    NSLog(@"SCPlayerController dealloc");
}

- (void)prepareToPlay {
    NSArray *keys = @[@"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset
                           automaticallyLoadedAssetKeys:keys];
    
    [self.playerItem addObserver:self
                      forKeyPath:kPlayerStatusKeyPath
                         options:0
                         context:&PlayerItemStatusContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerView = [SCPlayerView playerViewWithPlayer:self.player];
    self.displayer = self.playerView.displayer;
    self.displayer.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (context == &PlayerItemStatusContext) {
        // 播放器状态变换
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playerItem removeObserver:self forKeyPath:kPlayerStatusKeyPath];
            
            if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];
                
                [self.player play];
            } else {
                // TODO: - 错误弹窗
                NSLog(@"Play Error.");
            }
        });
    }
}

#pragma mark - Time Observers
- (void)addPlayerItemTimeObserver {
    __weak typeof(self) weakSelf = self;
    CMTime interval = CMTimeMakeWithSeconds(kReftesfInterval, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:nil usingBlock:^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.displayer setCurrentTime:currentTime duration:duration];
    }];
}

- (void)addItemEndObserverForPlayerItem {
    __weak typeof(self) weakSelf = self;
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [weakSelf.displayer playbackComplete];
            }];
        }];
    }];
}

#pragma mark - SCVideoDisplayDelegate
- (void)play {
    [self.player play];
}

- (void)pause {
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}

- (void)stop {
    [self.player setRate:0.0f];
    [self.displayer playbackComplete];
}

- (void)jumpedToTime:(NSTimeInterval)time {
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidStart {
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}

- (void)scrubbedToTime:(NSTimeInterval)time {
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidEnd {
    if (self.lastPlaybackRate > 0.0f) {
        [self.player play];
    }
}

#pragma mark - setter/getter
- (UIView *)view {
    return self.playerView;
}

@end

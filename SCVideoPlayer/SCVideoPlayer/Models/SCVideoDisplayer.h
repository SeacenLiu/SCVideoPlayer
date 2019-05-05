//
//  SCVideoDisplayer.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/5/5.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@protocol SCVideoDisplayerDelegate <NSObject>

- (void)play;
- (void)pause;
- (void)stop;

- (void)scrubbingDidStart;
- (void)scrubbedToTime:(NSTimeInterval)time;
- (void)scrubbingDidEnd;

- (void)jumpedToTime:(NSTimeInterval)time;

@end

@protocol SCVideoDisplayer <NSObject>

@property (nonatomic, weak) id<SCVideoDisplayerDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)playbackComplete;

@end

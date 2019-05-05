//
//  SCPlayerView.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCVideoDisplayer.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AVPlayer;
@interface SCPlayerView : UIView

- (instancetype)initWithPlayer:(AVPlayer*)player;
+ (instancetype)playerViewWithPlayer:(AVPlayer*)player;

@property (nonatomic, readonly) id<SCVideoDisplayer> displayer;

@end

NS_ASSUME_NONNULL_END

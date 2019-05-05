//
//  SCPlayerController.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPlayerController : NSObject

- (instancetype)initWithURL:(NSURL*)assetURL;
+ (instancetype)playerWithURL:(NSURL*)assetURL;

@property (nonatomic, strong, readonly) UIView *view;

@end

NS_ASSUME_NONNULL_END

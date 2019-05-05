//
//  SCThumbnail.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/5/5.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCThumbnail : NSObject

- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time;
+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time;

@property (nonatomic, readonly) CMTime time;
@property (strong, nonatomic, readonly) UIImage *image;

@end

NS_ASSUME_NONNULL_END

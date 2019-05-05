//
//  AVAsset+SCAdditions.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/5/5.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAsset (SCAdditions)

@property (nonatomic, readonly) NSString *title;

@end

NS_ASSUME_NONNULL_END

//
//  SCThumbnail.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/5/5.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCThumbnail.h"

@implementation SCThumbnail

- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time {
    if (self = [super init]) {
        _image = image;
        _time = time;
    }
    return self;
}

+ (instancetype)thumbnailWithImage:(UIImage *)image time:(CMTime)time {
    return [[self alloc] initWithImage:image time:time];
}

@end

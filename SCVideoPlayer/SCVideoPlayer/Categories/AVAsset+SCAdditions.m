//
//  AVAsset+SCAdditions.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/5/5.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "AVAsset+SCAdditions.h"

@implementation AVAsset (SCAdditions)

- (NSString *)title {
    AVKeyValueStatus status = [self statusOfValueForKey:@"commonMetadata" error:nil];
    if (status == AVKeyValueStatusLoaded) {
        NSArray *items =
        [AVMetadataItem metadataItemsFromArray:self.commonMetadata
                                       withKey:AVMetadataCommonKeyTitle
                                      keySpace:AVMetadataKeySpaceCommon];
        if (items.count > 0) {
            AVMetadataItem *titleItem = [items firstObject];
            return (NSString *)titleItem.value;
        }
    }
    
    return nil;
}

@end

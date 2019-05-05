//
//  SCPlayerViewController.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCPlayerViewController.h"
#import "SCPlayerController.h"

@interface SCPlayerViewController ()
@property (nonatomic, strong) SCPlayerController *playerController;
@end

@implementation SCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"miku" withExtension:@"mp4"];
    self.playerController = [SCPlayerController playerWithURL:fileURL];
    self.playerController.view.frame = self.view.frame;
    [self.view addSubview:self.playerController.view];
}



@end

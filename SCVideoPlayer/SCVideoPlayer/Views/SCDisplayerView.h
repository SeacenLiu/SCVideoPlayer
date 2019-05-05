//
//  SCOperatedView.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCVideoDisplayer.h"

@interface SCDisplayerView : UIView<SCVideoDisplayer>

+ (instancetype)operatedView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *filmstripToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *togglePlaybackButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *scrubberSlider;

@property (nonatomic, weak) id <SCVideoDisplayerDelegate> delegate;

- (IBAction)toggleControls:(id)sender;
- (IBAction)togglePlayback:(UIButton *)sender;
- (IBAction)closeWindow:(id)sender;
- (IBAction)toggleFilmstrip:(id)sender;

- (void)setCurrentTime:(NSTimeInterval)time;

@end

//
//  SCOperatedView.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "SCDisplayerView.h"
#import "UIView+SCAddition.h"

@interface SCDisplayerView() <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL controlsHidden;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL scrubbing;
@property (nonatomic, assign) CGFloat lastPlaybackRate;
@end

@implementation SCDisplayerView

+ (instancetype)operatedView {
    return [[NSBundle mainBundle] loadNibNamed:@"SCDisplayerView" owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self resetTimer];
}

- (void)setCurrentTime:(NSTimeInterval)time {
    [self.delegate jumpedToTime:time];
}

- (void)dealloc {
    NSLog(@"SCDisplayerView delloc");
}

#pragma mark - action
- (IBAction)toggleControls:(id)sender {
    [UIView animateWithDuration:0.35 animations:^{
        if (!self.controlsHidden) {
            self.navigationBar.top -= self.navigationBar.height;
            self.toolbar.top += self.toolbar.height;
        } else {
            self.navigationBar.top += self.navigationBar.height;
            self.toolbar.top -= self.toolbar.height;
        }
        self.controlsHidden = !self.controlsHidden;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetTimer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction)togglePlayback:(id)sender {
    UIButton *btn = self.togglePlaybackButton;
    btn.selected = !btn.selected;
    if (self.delegate) {
        if (btn.selected) {
            [self.delegate play];
        } else {
            [self.delegate pause];
        }
    }
}

- (IBAction)startScrubbing:(id)sender {
    self.scrubbing = YES;
    [self resetTimer];
    [self.delegate scrubbingDidStart];
}

- (IBAction)showScrubbing:(id)sender {
    [self.delegate scrubbedToTime:self.scrubberSlider.value];
}

- (IBAction)endScrubbing:(id)sender {
    self.scrubbing = NO;
    [self.delegate scrubbingDidEnd];
}

- (IBAction)closeWindow:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    [self.delegate stop];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toggleFilmstrip:(id)sender {
    // TODO: - 按帧跳转
}

#pragma mark - setupUI
- (void)resetTimer {
    [self.timer invalidate];
    if (!self.scrubbing) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
            if (self.timer.isValid && !self.controlsHidden) {
                [weakSelf toggleControls:nil];
            }
        }];
    }
}

#pragma mark - SCVideoDisplayer
- (void)setTitle:(NSString *)title {
    self.navigationBar.topItem.title = title ? title : @"Video Player";
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    NSInteger currentSeconds = ceil(time);
    double remainingTime = duration - time;
    self.currentTimeLabel.text = [self formatSeconds: currentSeconds];
    self.remainingTimeLabel.text = [self formatSeconds:remainingTime];
    self.scrubberSlider.minimumValue = 0.0f;
    self.scrubberSlider.maximumValue = duration;
    self.scrubberSlider.value = time;
}

- (void)playbackComplete {
    self.scrubberSlider.value = 0.0f;
    self.togglePlaybackButton.selected = NO;
}

#pragma mark - Tool
- (NSString *)formatSeconds:(NSInteger)value {
    NSInteger seconds = value % 60;
    NSInteger minutes = value / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long) minutes, (long) seconds];
}

@end

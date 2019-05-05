//
//  UIView+SCHUD.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/30.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "UIView+SCHUD.h"
#import <objc/runtime.h>

#define kSCAlertViewControllerKey "com.seacen.UIView.AlertController"

@implementation UIView (SCHUD)
@dynamic alertController;

#pragma mark - 加载框
- (void)showHUD:(NSString *)message {
    [self showHUD:message isLoading:NO];
}

- (void)showLoadingHUD:(NSString *)message {
    [self showHUD:message isLoading:YES];
}

/// 显示加载框(loading 为 YES 表示有菊花效果)
- (void)showHUD:(NSString *)message isLoading:(BOOL)isLoading {
    UIAlertController *alertController = [self getAlertController];
    alertController.message = [NSString stringWithFormat:@"\n\n\n%@", message];
    if (isLoading) {
        // 显示菊花
        [self findLabel:alertController.view success:^(UIView *label) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                activityView.color = [UIColor lightGrayColor];
                [label addSubview:activityView];
                [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:activityView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
                [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:activityView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-20]];
                [activityView startAnimating];
            });
        }];
    }
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)hideHUD {
    [[self getAlertController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 提示框
- (void)showAutoDismissHUD:(NSString *)message {
    [self showAutoDismissHUD:message delay:0.3];
}

- (void)showAutoDismissHUD:(NSString *)message delay:(NSTimeInterval)delay {
    UIAlertController *alertController = [self getAlertController];
    alertController.message = message;
    [self.viewController presentViewController:alertController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:delay
                                     target:self
                                   selector:@selector(hideHUD)
                                   userInfo:alertController repeats:NO];
}

#pragma mark - 弹出框
- (void)showError:(NSError*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertView:error.localizedDescription done:nil cancel:nil];
    });
}

- (void)showAlertView:(NSString *)message
                  done:(void(^)(UIAlertAction * action))done
              cancel:(void(^)(UIAlertAction * action))cancel {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancel];
        [alertController addAction:cancelAction];
    }
    if (done) {
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:done];
        [alertController addAction:doneAction];
    }
    if (cancel == nil && done == nil) {
        UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:knowAction];
    }
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - setter/getter
- (void)setAlertController:(UIAlertController *)alertController {
    if (alertController == nil)
        return;
    objc_setAssociatedObject(self, kSCAlertViewControllerKey, alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIAlertController *)alertController {
    NSObject *obj = objc_getAssociatedObject(self, kSCAlertViewControllerKey);
    if (obj && [obj isKindOfClass:[UIAlertController class]]) {
        return (UIAlertController*)obj;
    }
    return nil;
}

- (UIAlertController *)getAlertController{
    if (!self.alertController) {
        self.alertController = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    }
    return self.alertController;
}

#pragma mark - private method
- (void)findLabel:(UIView*)view success:(void(^)(UIView *label))success{
    for (UIView* subView in view.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]]) {
            if (success) {
                success(subView);
            }
        }
        [self findLabel:subView success:success];
    }
}

- (UIViewController*)viewController {
    if ([[self nextResponder] isKindOfClass:[UIViewController class]]) {
        return (UIViewController*)[self nextResponder];
    }
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextRespinder = [next nextResponder];
        if ([nextRespinder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextRespinder;
        }
    }
    return nil;
}

@end

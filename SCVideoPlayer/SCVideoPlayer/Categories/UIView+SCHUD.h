//
//  UIView+SCHUD.h
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/30.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 方便使用加载框、弹出框、提示框
 
 @disssion 内存中可能会一直存在一个 alertController，若需要去除在 hideHUD 方法的实现中置空即可!
 */
@interface UIView (SCHUD)

@property(nonatomic, strong ,readonly) UIAlertController *alertController;

#pragma mark - 加载框
/**
 加载框（无菊花）

 @param message 加载信息
 */
- (void)showHUD:(NSString *)message;

/**
 加载框（有菊花）
 
 @param message 加载信息
 */
- (void)showLoadingHUD:(NSString *)message;

/**
 隐藏加载框
 */
- (void)hideHUD;

#pragma mark - 提示框

/**
 展示自动消失提示框，默认显示 0.3 秒

 @param message 提示信息
 */
- (void)showAutoDismissHUD:(NSString *)message;

/**
 展示自动消失提示框

 @param message 提示信息
 @param delay 延迟秒数
 */
- (void)showAutoDismissHUD:(NSString *)message delay:(NSTimeInterval)delay;


#pragma mark - 弹出框
/**
 错误弹出提示框

 @param error 需要弹出的错误
 */
- (void)showError:(NSError*)error;

/**
 弹出信息框
 @disssion done 和 cancel 都为 nil 的情况下，弹出框显示一个"知道了"按钮，无特殊效果
 
 @param message 需要弹出的信息
 @param done 确认操作(nil表示无确认操作)
 @param cancel 取消操作(nil表示无取消操作)
 */
- (void)showAlertView:(NSString *)message
                  done:(void(^)(UIAlertAction * action))done
              cancel:(void(^)(UIAlertAction * action))cancel;

@end

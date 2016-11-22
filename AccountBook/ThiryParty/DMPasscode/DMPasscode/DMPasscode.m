//
//  DMPasscode.m
//  DMPasscode
//
//  Created by Dylan Marriott on 20/09/14.
//  Copyright (c) 2014 Dylan Marriott. All rights reserved.
//

#import "DMPasscode.h"
#import "DMPasscodeInternalNavigationController.h"
#import "DMPasscodeInternalViewController.h"
#import "DMKeychain.h"

static DMPasscode* instance;
static const NSString* KEYCHAIN_NAME = @"passcode";
NSString * const DMUnlockErrorDomain = @"com.dmpasscode.error.unlock";

@interface DMPasscode () <DMPasscodeInternalViewControllerDelegate>
@end

@implementation DMPasscode {
    PasscodeCompletionBlock _completion;
    PasscodeWillCloseBlock _willClose;
    DMPasscodeInternalViewController* _passcodeViewController;
    int _mode; // 0 = setup, 1 = input
    int _count;
    NSString* _prevCode;
    DMPasscodeConfig* _config;
}

+ (void)initialize {
    [super initialize];
    instance = [[DMPasscode alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _config = [[DMPasscodeConfig alloc] init];
    }
    return self;
}

#pragma mark - Public
+ (void)setupPasscodeInViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                     willCloseHandler:(PasscodeWillCloseBlock)willCloseHandler
                           completion:(PasscodeCompletionBlock)completion {
    [instance setupPasscodeInViewController:viewController
                                   animated:animated
                           willCloseHandler:willCloseHandler
                                 completion:completion];
}

+ (void)showPasscodeInViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                    willCloseHandler:(PasscodeWillCloseBlock)willCloseHandler
                          completion:(PasscodeCompletionBlock)completion {
    [instance showPasscodeInViewController:viewController
                                  animated:animated
                          willCloseHandler:willCloseHandler
                                completion:completion];
}

+ (void)removePasscode {
    [instance removePasscode];
}

+ (BOOL)isPasscodeSet {
    return [instance isPasscodeSet];
}

+ (void)setConfig:(DMPasscodeConfig *)config {
    [instance setConfig:config];
}

#pragma mark - Instance methods
- (void)setupPasscodeInViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                     willCloseHandler:(PasscodeWillCloseBlock)willCloseHandler
                           completion:(PasscodeCompletionBlock)completion {
    _completion = completion;
    _willClose = willCloseHandler;
    [self openPasscodeWithMode:0 viewController:viewController animated:animated];
}

- (void)showPasscodeInViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                    willCloseHandler:(PasscodeWillCloseBlock)willCloseHandler
                          completion:(PasscodeCompletionBlock)completion {
    NSAssert([self isPasscodeSet], @"No passcode set");
    _completion = completion;
    _willClose = willCloseHandler;
    [self openPasscodeWithMode:1 viewController:viewController animated:animated];
}

- (void)removePasscode {
    [[DMKeychain defaultKeychain] removeObjectForKey:KEYCHAIN_NAME];
}

- (BOOL)isPasscodeSet {
    BOOL ret = [[DMKeychain defaultKeychain] objectForKey:KEYCHAIN_NAME] != nil;
    return ret;
}

- (void)setConfig:(DMPasscodeConfig *)config {
    _config = config;
}

#pragma mark - Private
- (void)openPasscodeWithMode:(int)mode viewController:(UIViewController *)viewController animated:(BOOL)animated {
    _mode = mode;
    _count = 0;
    _passcodeViewController = [[DMPasscodeInternalViewController alloc] initWithDelegate:self mode:mode config:_config];
    DMPasscodeInternalNavigationController* nc = [[DMPasscodeInternalNavigationController alloc] initWithRootViewController:_passcodeViewController];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [viewController presentViewController:nc animated:animated completion:nil];
    if (_mode == 0) {
        [_passcodeViewController setInstructions:@"输入新的密码"];
    } else if (_mode == 1) {
        [_passcodeViewController setInstructions:@"输入密码"];
    }
}

- (void)closeAndNotify:(BOOL)success withError:(NSError *)error {
    
    if(_willClose)
    {
        _willClose();
    }
    
    [_passcodeViewController dismissViewControllerAnimated:YES completion:^() {
        _completion(success, error);
    }];
}

#pragma mark - DMPasscodeInternalViewControllerDelegate
- (void)fingerprintRecognitionSuccessed
{
    [self closeAndNotify:YES withError:nil];
}

- (void)enteredCode:(NSString *)code {
    if (_mode == 0) {
        if (_count == 0) {
            _prevCode = code;
            [_passcodeViewController setInstructions:@"重新输入"];
            [_passcodeViewController setErrorMessage:@""];
            [_passcodeViewController reset];
        } else {
            if ([code isEqualToString:_prevCode]) {
                [[DMKeychain defaultKeychain] setObject:code forKey:KEYCHAIN_NAME];
                [self closeAndNotify:YES withError:nil];
                _count = 0;
            } else {
                [_passcodeViewController setInstructions:@"输入新的密码"];
                [_passcodeViewController setErrorMessage:@"密码错误，重新输入"];
                [_passcodeViewController reset];
                _count = 0;
                return;
            }
        }
    } else if (_mode == 1) {
        if ([code isEqualToString:[[DMKeychain defaultKeychain] objectForKey:KEYCHAIN_NAME]]) {
            [self closeAndNotify:YES withError:nil];
        } else {
            [_passcodeViewController setErrorMessage:@"密码错误"];
            [_passcodeViewController reset];
        }
    }
    _count++;
}

- (void)canceled {
    
    if(_willClose)
    {
        _willClose();
    }
    _completion(NO, nil);
}

@end

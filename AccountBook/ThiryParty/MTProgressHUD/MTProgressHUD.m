//
//  MTProgressHUD.m
//  MTProgressHUDDemo
//
//  Created by zhourongqing on 16/1/27.
//  Copyright © 2016年 mtry. All rights reserved.
//

#import "MTProgressHUD.h"

typedef NS_ENUM(NSInteger, MTProgressHUDMessageType)
{
    MTProgressHUDMessageTypeInfo,
    MTProgressHUDMessageTypeSuccess,
    MTProgressHUDMessageTypeError,
    MTProgressHUDMessageTypeLoading,
    MTProgressHUDMessageTypeCustom,
};

NSString *const MTProgressHUDWillShowNotification = @"MTProgressHUDWillShowNotification";
NSString *const MTProgressHUDDidShowNotification = @"MTProgressHUDDidShowNotification";
NSString *const MTProgressHUDWillCloseNotification = @"MTProgressHUDWillCloseNotification";
NSString *const MTProgressHUDDidCloseNotification = @"MTProgressHUDDidCloseNotification";

static UIColor *MTProgressHUDBackgroudColor;
static UIColor *MTProgressHUDForegroudColor;
static UIFont  *MTProgressHUDFont;
static UIImage *MTProgressHUDInfoImage;
static UIImage *MTProgressHUDErrorImage;
static UIImage *MTProgressHUDSuccessImage;
static MTProgressHUDMaskType MTProgressHUDDefaultMaskType;

static const CGFloat MTProgressHUDImageSize = 24.0f;
static const CGFloat MTProgressHUDMessageLeftRightMarge = 10.0f;
static const CGFloat MTProgressHUDTopBottomMarge = 15.0f;
static const CGFloat MTProgressHUDImageToMessageSpace = 15.0f;
static const CGFloat MTProgressHUDContentViewCenterYScale = 0.45f;

#pragma mark - MTProgressHUDContentView

@interface MTProgressHUDContentView : UIView

@property (nonatomic) MTProgressHUDMessageType messageType;

@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic, readonly) UILabel *titleLabel;

@property (nonatomic, readonly) UIActivityIndicatorView *indicatorView;

@end

@implementation MTProgressHUDContentView

@synthesize indicatorView = _indicatorView;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if(!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}

- (void)drawRect:(CGRect)rect
{
    CGRect imageFrame = CGRectZero;
    imageFrame.origin.x = (CGRectGetWidth(rect) - MTProgressHUDImageSize) / 2;
    imageFrame.size = CGSizeMake(MTProgressHUDImageSize, MTProgressHUDImageSize);
    
    [self.imageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.indicatorView removeFromSuperview];
    
    if(self.titleLabel.text.length)
    {
        [self addSubview:self.titleLabel];
        imageFrame.origin.y = MTProgressHUDTopBottomMarge;
    }
    else
    {
        imageFrame.origin.y = (CGRectGetHeight(rect) - CGRectGetHeight(imageFrame)) / 2;
    }
    
    if(self.messageType == MTProgressHUDMessageTypeLoading)
    {
        CGFloat scale = MTProgressHUDImageSize / CGRectGetWidth(self.indicatorView.frame);
        self.indicatorView.center = CGPointMake(CGRectGetMidX(imageFrame), CGRectGetMidY(imageFrame));
        self.indicatorView.transform = CGAffineTransformMakeScale(scale, scale);
        self.indicatorView.color = self.titleLabel.textColor;
        [self.indicatorView startAnimating];
        [self addSubview:self.indicatorView];
    }
    else
    {
        if(self.imageView.image)
        {
            self.imageView.frame = imageFrame;
            [self addSubview:self.imageView];
        }
        else
        {
            if(self.messageType == MTProgressHUDMessageTypeInfo)
            {
                [self drawInfoRect:imageFrame];
            }
            else if(self.messageType == MTProgressHUDMessageTypeSuccess)
            {
                [self drawSuccessRect:imageFrame];
            }
            else if(self.messageType == MTProgressHUDMessageTypeError)
            {
                [self drawErrorRect:imageFrame];
            }
        }
    }
    
    BOOL isExistImage = (self.messageType == MTProgressHUDMessageTypeCustom && self.imageView.image == nil) ? NO : YES;
    CGRect titleFrame = CGRectZero;
    titleFrame.origin.x = MTProgressHUDMessageLeftRightMarge;
    titleFrame.origin.y = isExistImage ? CGRectGetMaxY(imageFrame) + MTProgressHUDImageToMessageSpace : MTProgressHUDTopBottomMarge;
    titleFrame.size.width = CGRectGetWidth(rect) - MTProgressHUDMessageLeftRightMarge * 2;
    titleFrame.size.height = CGRectGetHeight(rect) - titleFrame.origin.y - MTProgressHUDTopBottomMarge;
    self.titleLabel.frame = titleFrame;
}

- (void)drawInfoRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.titleLabel.textColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    
    //圆
    CGFloat x = CGRectGetMidX(rect);
    CGFloat y = CGRectGetMidY(rect);
    CGFloat radius = CGRectGetWidth(rect) / 2;
    CGFloat startAngle = 0;
    CGFloat endAngle = M_PI * 2;
    int     clockwise = 0;
    CGContextAddArc(ctx, x, y, radius, startAngle, endAngle, clockwise);
    CGContextStrokePath(ctx);
    
    //i
    UIFont *font = [UIFont systemFontOfSize:18];
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:self.titleLabel.textColor};
    NSString *text = @"i";
    CGFloat textWidth = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil].size.width;
    CGFloat textHeight = font.lineHeight;
    [text drawInRect:CGRectMake(x - textWidth/2, y - textHeight/2, textWidth, textHeight) withAttributes:attributes];
}

- (void)drawSuccessRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.titleLabel.textColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    /* p1p2垂直p2p3且p1p2/p2p3=3/7；相对rect.point的关系
     * p1_y = (4 * size + 3 * p2_x) / 7;
     * p3_y = (3 * size - 7 * p2_x) / 3;
     * 0 < p2_x <= size * 3 / 7;
     */
    CGFloat size = CGRectGetWidth(rect);
    CGPoint point1, point2, point3;
    CGFloat p2_x = size * 3 / 10;
    
    point2.x = CGRectGetMinX(rect) + p2_x;
    point2.y = CGRectGetMaxY(rect);
    
    point3.x = CGRectGetMaxX(rect);
    point3.y = CGRectGetMinY(rect) + (3 * size - 7 * p2_x) / 3;
    
    point1.x = CGRectGetMinX(rect);
    point1.y = CGRectGetMinY(rect) + (4 * size + 3 * p2_x) / 7;
    
    CGPoint points[] = {point1, point2, point3};
    CGContextAddLines(ctx, points, 3);
    CGContextStrokePath(ctx);
}

- (void)drawErrorRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.titleLabel.textColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGFloat reduceDistance = 2;
    CGPoint point1, point2;
    point1.x = CGRectGetMinX(rect) + reduceDistance;
    point1.y = CGRectGetMinY(rect) + reduceDistance;
    point2.x = CGRectGetMaxX(rect) - reduceDistance;
    point2.y = CGRectGetMaxY(rect) - reduceDistance;
    CGPoint line1[] = {point1, point2};
    CGContextAddLines(ctx, line1, 2);
    
    point1.x = CGRectGetMinX(rect) + reduceDistance;
    point1.y = CGRectGetMaxY(rect) - reduceDistance;
    point2.x = CGRectGetMaxX(rect) - reduceDistance;
    point2.y = CGRectGetMinY(rect) + reduceDistance;
    CGPoint line2[] = {point1, point2};
    CGContextAddLines(ctx, line2, 2);
    
    CGContextStrokePath(ctx);
}

@end

#pragma mark - MTProgressHUD

@interface MTProgressHUD ()

@property (nonatomic, readonly) UIControl *maskView;
@property (nonatomic, readonly) MTProgressHUDContentView *contentView;

@property (nonatomic, weak) UIView *inView;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) UIColor *contentBackgroudColor;
@property (nonatomic, readonly) UIColor *contentForegroudColor;
@property (nonatomic, readonly) UIFont  *font;
@property (nonatomic, readonly) MTProgressHUDMaskType maskType;
@property (nonatomic, readonly) MTProgressHUDMessageType messageType;

@property (nonatomic, readonly) NSTimer *autoCloseTimer;

@end

@implementation MTProgressHUD

@synthesize maskView = _maskView;
@synthesize contentView = _contentView;

@synthesize message = _message;
@synthesize image = _image;

@synthesize contentBackgroudColor = _contentBackgroudColor;
@synthesize contentForegroudColor = _contentForegroudColor;
@synthesize font = _font;
@synthesize maskType = _maskType;
@synthesize messageType = _messageType;

@synthesize autoCloseTimer = _autoCloseTimer;

#pragma mark 属性

- (UIControl *)maskView
{
    if(!_maskView)
    {
        _maskView = [[UIControl alloc] initWithFrame:self.bounds];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_maskView addTarget:self action:@selector(touchUpInsideMaskView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskView;
}

- (MTProgressHUDContentView *)contentView
{
    if(!_contentView)
    {
        _contentView = [[MTProgressHUDContentView alloc] init];
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

#pragma mark 生命周期

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [self removeNotifications];
    
    if(self.autoCloseTimer)
    {
        [self.autoCloseTimer invalidate];
        _autoCloseTimer = nil;
    }
}

#pragma mark 显示和关闭

- (void)showAnimate:(BOOL)isAnimate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTProgressHUDWillShowNotification object:nil];
    
    self.frame = self.inView.bounds;
    
    switch (self.maskType)
    {
        case MTProgressHUDMaskTypeNone:
            self.userInteractionEnabled = NO;
            break;
        case MTProgressHUDMaskTypeClear:
            [self addSubview:self.maskView];
            self.maskView.backgroundColor = [UIColor clearColor];
            break;
        case MTProgressHUDMaskTypeBlack:
            [self addSubview:self.maskView];
            self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            break;
        default:
            break;
    }
    
    self.contentView.messageType = self.messageType;
    self.contentView.backgroundColor = self.contentBackgroudColor;
    self.contentView.titleLabel.textColor = self.contentForegroudColor;
    self.contentView.titleLabel.font = self.font;
    self.contentView.titleLabel.text = self.message;
    self.contentView.imageView.image = self.image;
    
    [self.inView addSubview:self];
    [self addSubview:self.contentView];
    
    [self customLayoutSubviews];
    [self registerNotifications];
    
    if(isAnimate)
    {
        self.maskView.alpha = self.maskType == MTProgressHUDMaskTypeBlack ? 0 : 0.5;
        self.contentView.alpha = 0;
        self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.3, 1.3);
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.maskView.alpha = 0.5;
                             self.contentView.alpha = 1;
                             self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1/1.3, 1/1.3);
                         }completion:^(BOOL finished) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:MTProgressHUDDidShowNotification object:nil];
                         }];
    }
    else
    {
        [self.contentView setNeedsDisplay];
        [[NSNotificationCenter defaultCenter] postNotificationName:MTProgressHUDDidShowNotification object:nil];
    }
    
    if(self.messageType != MTProgressHUDMessageTypeLoading)
    {
        if(self.autoCloseTimer)
        {
            [self.autoCloseTimer invalidate];
            _autoCloseTimer = nil;
        }
        
        NSTimeInterval interval = fmin(self.message.length * 0.06 + 0.5, 5.0);
        _autoCloseTimer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(onAutoCloseTimer) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.autoCloseTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)closeAnimate:(BOOL)isAnimate
{
    if(self.autoCloseTimer)
    {
        [self.autoCloseTimer invalidate];
        _autoCloseTimer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTProgressHUDWillCloseNotification object:nil];
    
    if(isAnimate)
    {
        self.alpha = 1;
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             
                             [self.contentView removeFromSuperview];
                             _contentView = nil;
                             
                             [self removeFromSuperview];
                             [self removeNotifications];
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:MTProgressHUDDidCloseNotification object:nil];
                         }];
    }
    else
    {
        [self.contentView removeFromSuperview];
        _contentView = nil;
        
        [self removeFromSuperview];
        [self removeNotifications];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MTProgressHUDDidCloseNotification object:nil];
    }
}

#pragma mark 事件

- (void)touchUpInsideMaskView:(id)sender
{
    if(self.messageType != MTProgressHUDMessageTypeLoading)
    {
        [self closeAnimate:YES];
    }
}

- (void)onAutoCloseTimer
{
    [self closeAnimate:YES];
}

#pragma mark 布局

- (void)customLayoutSubviews
{
    CGSize contentMinSize = CGSizeMake(90, 90);
    CGSize contentMaxSize = CGSizeMake(200, 300);
    CGRect contentViewFrame = CGRectMake(0, 0, contentMinSize.width, contentMinSize.height);
    
    CGSize imageSize = CGSizeMake(MTProgressHUDImageSize, MTProgressHUDImageSize);
    CGSize titleSize = CGSizeZero;
    if(self.messageType == MTProgressHUDMessageTypeCustom && self.image == nil)
    {
        imageSize = CGSizeZero;
    }
    if(self.message.length)
    {
        titleSize = [self.message boundingRectWithSize:CGSizeMake(contentMaxSize.width - MTProgressHUDMessageLeftRightMarge * 2, contentMaxSize.height)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:self.font}
                                               context:nil].size;
        titleSize.height = ceil(titleSize.height);
    }
    
    if(CGSizeEqualToSize(imageSize, CGSizeZero) && !CGSizeEqualToSize(titleSize, CGSizeZero))
    {//文本
        contentViewFrame.size.width = fmax(titleSize.width + MTProgressHUDMessageLeftRightMarge * 2, contentMinSize.width);
        contentViewFrame.size.height = fmin(titleSize.height + MTProgressHUDTopBottomMarge * 2, contentMaxSize.height);
    }
    else if(!CGSizeEqualToSize(imageSize, CGSizeZero) && CGSizeEqualToSize(titleSize, CGSizeZero))
    {//图片
        contentViewFrame.size = contentMinSize;
    }
    else if(!CGSizeEqualToSize(imageSize, CGSizeZero) && !CGSizeEqualToSize(titleSize, CGSizeZero))
    {//图片和文本
        contentViewFrame.size.width = fmax(titleSize.width + MTProgressHUDMessageLeftRightMarge * 2, contentMinSize.width);
        contentViewFrame.size.height = fmin(imageSize.height + titleSize.height + MTProgressHUDTopBottomMarge * 2 + MTProgressHUDImageToMessageSpace, contentMaxSize.height);
    }
    
    self.contentView.frame = contentViewFrame;
    
    if([self.inView isKindOfClass:[UIWindow class]])
    {
        self.contentView.center = CGPointMake(self.center.x, (CGRectGetHeight(self.frame) - [self visibleKeyboardHeight]) * MTProgressHUDContentViewCenterYScale);
    }
    else
    {
        self.contentView.center = CGPointMake(self.center.x, CGRectGetHeight(self.frame) * MTProgressHUDContentViewCenterYScale);
    }
}

- (void)updatePositionNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:UIApplicationDidChangeStatusBarOrientationNotification])
    {
        self.contentView.center = CGPointMake(self.center.x, CGRectGetHeight(self.frame) * MTProgressHUDContentViewCenterYScale);
    }
    else if([notification.name isEqualToString:UIKeyboardWillShowNotification] ||
            [notification.name isEqualToString:UIKeyboardWillHideNotification])
    {
        if(![self.inView isKindOfClass:[UIWindow class]])
        {
            return;
        }
        
        CGFloat keyboardHeight = 0.0;
        double animationDuration = 0.0;
        
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        keyboardHeight = CGRectGetHeight(keyboardFrame);
        
        if([notification.name isEqualToString:UIKeyboardWillShowNotification])
        {
            self.contentView.center = CGPointMake(self.center.x, CGRectGetHeight(self.frame) * MTProgressHUDContentViewCenterYScale);
            [UIView animateWithDuration:animationDuration
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.contentView.center = CGPointMake(self.center.x, (CGRectGetHeight(self.frame) - keyboardHeight) * MTProgressHUDContentViewCenterYScale);
                             }completion:nil];
        }
        else
        {
            self.contentView.center = CGPointMake(self.center.x, (CGRectGetHeight(self.frame) - keyboardHeight) * MTProgressHUDContentViewCenterYScale);
            [UIView animateWithDuration:animationDuration
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.contentView.center = CGPointMake(self.center.x, CGRectGetHeight(self.frame) * MTProgressHUDContentViewCenterYScale);
                             }completion:nil];
        }
        
    }
}

#pragma mark 通知

- (void)registerNotifications
{
    [self removeNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePositionNotification:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePositionNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePositionNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 其它

- (CGFloat)visibleKeyboardHeight
{
    UIWindow *keyboardWindow = nil;
    for(UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if(![[window class] isEqual:[UIWindow class]])
        {
            keyboardWindow = window;
            break;
        }
    }
    
    for(__strong UIView *possibleKeyboard in [keyboardWindow subviews])
    {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] ||
           [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
        {
            return CGRectGetHeight(possibleKeyboard.bounds);
        }
        else if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")])
        {
            for(__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews])
            {
                if([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")])
                {
                    return CGRectGetHeight(possibleKeyboardSubview.bounds);
                }
            }
        }
    }
    return 0;
}

#pragma mark 自定义样式

+ (void)setBackgroudColor:(UIColor *)color
{
    MTProgressHUDBackgroudColor = color;
}

+ (void)setForegroudColor:(UIColor *)color
{
    MTProgressHUDForegroudColor = color;
}

+ (void)setFont:(UIFont *)font
{
    MTProgressHUDFont = font;
}

+ (void)setInfoImage:(UIImage *)image
{
    MTProgressHUDInfoImage = image;
}

+ (void)setErrorImage:(UIImage *)image
{
    MTProgressHUDErrorImage = image;
}

+ (void)setSuccessImage:(UIImage *)image
{
    MTProgressHUDSuccessImage = image;
}

+ (void)setMaskType:(MTProgressHUDMaskType)maskType
{
    MTProgressHUDDefaultMaskType = maskType;
}

#pragma mark 显示和关闭

+ (void)showInfoWithMessage:(NSString *)message
{
    [self showMessage:message image:MTProgressHUDInfoImage inView:nil messgeType:MTProgressHUDMessageTypeInfo];
}

+ (void)showInfoWithMessage:(NSString *)message inView:(UIView *)inView
{
    [self showMessage:message image:MTProgressHUDInfoImage inView:inView messgeType:MTProgressHUDMessageTypeInfo];
}

+ (void)showErrorWithMessge:(NSString *)message
{
    [self showMessage:message image:MTProgressHUDErrorImage inView:nil messgeType:MTProgressHUDMessageTypeError];
}

+ (void)showErrorWithMessge:(NSString *)message inView:(UIView *)inView
{
    [self showMessage:message image:MTProgressHUDErrorImage inView:inView messgeType:MTProgressHUDMessageTypeError];
}

+ (void)showSuccessWithMessage:(NSString *)message
{
    [self showMessage:message image:MTProgressHUDSuccessImage inView:nil messgeType:MTProgressHUDMessageTypeSuccess];
}

+ (void)showSuccessWithMessage:(NSString *)message inView:(UIView *)inView
{
    [self showMessage:message image:MTProgressHUDSuccessImage inView:inView messgeType:MTProgressHUDMessageTypeSuccess];
}

+ (void)showLoadingWithMessage:(NSString *)message
{
    [self showMessage:message image:nil inView:nil messgeType:MTProgressHUDMessageTypeLoading];
}

+ (void)showLoadingWithMessage:(NSString *)message inView:(UIView *)inView
{
    [self showMessage:message image:nil inView:inView messgeType:MTProgressHUDMessageTypeLoading];
}

+ (void)showCustomWithMessage:(NSString *)message image:(UIImage *)image
{
    [self showMessage:message image:image inView:nil messgeType:MTProgressHUDMessageTypeCustom];
}

+ (void)showCustomWithMessage:(NSString *)message image:(UIImage *)image inView:(UIView *)inView
{
    [self showMessage:message image:image inView:inView messgeType:MTProgressHUDMessageTypeCustom];
}

+ (void)showMessage:(NSString *)message image:(UIImage *)image inView:(UIView *)inView messgeType:(MTProgressHUDMessageType)messageType
{
    if(!inView)
    {
        inView = [self systemDefualtWindow];
        if(!inView)
        {
            return;
        }
    }
    
    BOOL isExistHud = NO;
    MTProgressHUD *hud;
    for(MTProgressHUD *subView in inView.subviews)
    {
        if([subView isKindOfClass:[MTProgressHUD class]])
        {
            [inView bringSubviewToFront:subView];
            hud = subView;
            isExistHud = YES;
            break;
        }
    }
    
    if(!hud)
    {
        hud = [MTProgressHUD new];
        [inView addSubview:hud];
    }
    else
    {
        [hud closeAnimate:NO];
    }
    
    hud->_message = message;
    hud->_image = image;
    hud->_inView = inView;
    
    hud->_contentBackgroudColor = MTProgressHUDBackgroudColor ? MTProgressHUDBackgroudColor : [UIColor blackColor];
    hud->_contentForegroudColor = MTProgressHUDForegroudColor ? MTProgressHUDForegroudColor : [UIColor whiteColor];
    hud->_font = MTProgressHUDFont ? MTProgressHUDFont : [UIFont systemFontOfSize:12];
    hud->_maskType = MTProgressHUDDefaultMaskType ? MTProgressHUDDefaultMaskType : MTProgressHUDMaskTypeNone;
    hud->_messageType = messageType;
    
    [hud showAnimate:!isExistHud];
}

+ (void)close
{
    [self closeInView:[self systemDefualtWindow]];
}

+ (void)closeInView:(UIView *)inView
{
    if(!inView)
    {
        return;
    }
    
    for(MTProgressHUD *subView in inView.subviews)
    {
        if([subView isKindOfClass:[MTProgressHUD class]])
        {
            [subView closeAnimate:YES];
            break;
        }
    }
}

#pragma mark 其它

+ (UIWindow *)systemDefualtWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for(UIWindow *window in frontToBackWindows)
    {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
        {
            return window;
        }
    }
    return nil;
}

@end
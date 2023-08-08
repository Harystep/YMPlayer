#import "SJPushCoinGameControlView.h"
#import "AppDefineHeader.h"
#import "Masonry.h"
#import "PPCountDownView.h"
#import "PPGameControlView.h"
#import "UIColor+MCUIColorsUtils.h"
#import "POP.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

@interface SJPushCoinGameControlView ()
@property (nonatomic, weak) UIButton * theSendMessageButton;
@property (nonatomic, weak) UIButton * theRechargeButton;
@property (nonatomic, weak) PPGameStartButton * theGameButton;
@property (nonatomic, assign) BOOL isGaming;
@property (nonatomic, weak) PPCountDownView * theCountDownView;
@property (nonatomic, weak) UIView * thePlayControlView;
@property (nonatomic, weak) UIButton * theFirstCoinButton;
@property (nonatomic, weak) UIButton * theSectionCoinButton;
@end
@implementation SJPushCoinGameControlView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SF_Float(140));
        self.gameDoneSubject = [RACSubject subject];
        self.pushCoinSubject = [RACSubject subject];
        [self configView];
    }
    return self;
}
#pragma mark - config
- (void)configView {
//    [self theSendMessageButton];
//    [self theRechargeButton];
    [self theGameButton].btStatus = startAction;
    [self theFirstCoinButton];
    [self theSectionCoinButton];
    @weakify_self(self);
    [[self theCountDownView].gameOverSubject subscribeNext:^(id  _Nullable x) {
        @strongify_self(self);
        [self.pushCoinSubject sendNext:@(0)];
    }];
}
#pragma mark - set
- (void)setGamePrice:(NSString *)gamePrice {
    _gamePrice = gamePrice;
    self.theGameButton.gamePrice = self.gamePrice;
}
- (void)setBtStatus:(GameButtonStatus)btStatus {
    _btStatus = btStatus;
    [self theGameButton].btStatus = btStatus;
}
- (void)setCountDownTime:(NSInteger)countDownTime {
    _countDownTime = countDownTime;
    self.theCountDownView.countDownTime = countDownTime;
}
- (void)setMaxCountDownTime:(NSInteger)maxCountDownTime {
    _maxCountDownTime = maxCountDownTime;
    self.theCountDownView.maxCountDownTime = maxCountDownTime;
}
- (void)setAppointmentCount:(NSInteger)appointmentCount {
    _appointmentCount = appointmentCount;
    DLog(@"[appointment] -> count = %ld", appointmentCount);
    self.theGameButton.appointmentCount = appointmentCount;
    if (self.appointmentCount == 0) {
        if (!self.isGaming) {
            [self definePlayGame];
        }
    }
    if (self.appointmentCount >= 0) {
        if (!self.isGaming) {
            if (self.theGameButton.btStatus == cancelAppointmentAction) {
            } else {
                if (self.appointmentCount > 0) {
                    [self.theGameButton showAppointmentInfo];
                } else {
                    self.theGameButton.btStatus = startAction;
                }
            }
        }
    }
    
}
#pragma mark - public method
- (void)startToPlayGame {
    POPBasicAnimation * hideAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnimation.toValue = @(0);
    hideAnimation.duration = 0.3;
    [self.theGameButton pop_addAnimation:hideAnimation forKey:@"hide_animation"];
    POPBasicAnimation *  showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation.toValue = @(1);
    showAnimation.duration = 0.3;
    showAnimation.beginTime = CACurrentMediaTime() + 0.3;
    [self.thePlayControlView pop_addAnimation:showAnimation forKey:@"show_animation"];
    self.isGaming = true;
    [self.theCountDownView startAnimation];
    self.theCountDownView.hidden = false;
}
- (void)startCountDownTimer{
    [self.theCountDownView startAnimation];
    self.theCountDownView.hidden = false;
}
- (void)stopCountDownTimer {
    [self.theCountDownView stopAnimation];
    self.theCountDownView.hidden = true;
}
- (void)definePlayGame {
    self.theGameButton.alpha = 1;
    self.thePlayControlView.alpha = 0;
    self.isGaming = false;
    [self stopCountDownTimer];
    [self.thePlayControlView pop_removeAnimationForKey:@"show_animation"];
    NSLog(@"[game] ---> definePlayGame");
}
- (void)defineOtherPlayGame{
    [self definePlayGame];
    self.isGaming = true;
    NSLog(@"[game] ---> defineOtherPlayGame");
    
}
#pragma mark - action
- (void)onSendMessagePress:(id)sender {
    [self.gameDoneSubject sendNext: @(sendMessage)];
}
- (void)onRechargePress:(id)sender {
    [self.gameDoneSubject sendNext:@(recharge)];
}
- (void)onGameStartPress:(id)sender {
    [self.gameDoneSubject sendNext: @(playStartGame)];
}
- (void)onPushCoinPress:(id)sender {
    [self.pushCoinSubject sendNext:sender];
}
#pragma mark - lazy UI
- (UIButton * )theSendMessageButton{
    if (!_theSendMessageButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(SF_Float(63));
            make.width.mas_equalTo(SF_Float(116));
            make.height.mas_equalTo(SF_Float(113));
            make.centerY.equalTo(self);
        }];
        theView.hidden = YES;
        [theView setImage:[PPImageUtil imageNamed:@"img_dbj_msg_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onSendMessagePress:) forControlEvents:UIControlEventTouchUpInside];
        _theSendMessageButton = theView;
    }
    return _theSendMessageButton;
}
- (UIButton * )theRechargeButton{
    if (!_theRechargeButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-SF_Float(63));
            make.width.mas_equalTo(SF_Float(116));
            make.height.mas_equalTo(SF_Float(113));
            make.centerY.equalTo(self);
        }];
        theView.hidden = YES;
        [theView setImage:[PPImageUtil imageNamed:@"img_dbj_recharge_a"] forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onRechargePress:) forControlEvents:UIControlEventTouchUpInside];
        _theRechargeButton = theView;
    }
    return _theRechargeButton;
}
- (PPGameStartButton * )theGameButton{
    if (!_theGameButton) {
        PPGameStartButton * theView = [[PPGameStartButton alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(SF_Float(500));
            make.height.mas_equalTo(SF_Float(92));
            make.centerY.equalTo(self);
        }];
        theView.startGameImage = [PPImageUtil imageNamed:@"push_coin_start_bg"];
        theView.appointmentImage = [PPImageUtil imageNamed:@"push_coin_start_bg"];
        theView.cancelAppointmentImage = [PPImageUtil imageNamed:@"push_coin_start_bg"];
        [theView addTarget:self action:@selector(onGameStartPress:) forControlEvents:UIControlEventTouchUpInside];
        _theGameButton = theView;
    }
    return _theGameButton;
}
- (UIView * )thePlayControlView{
    if (!_thePlayControlView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(SF_Float(50));
            make.trailing.mas_equalTo(self).inset(SF_Float(192));
            make.height.mas_equalTo(SF_Float(92));
            make.centerY.equalTo(self);
        }];
        theView.alpha = 0;
        UIImageView *bgIv = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"push_coin_start_bg"]];
        [theView addSubview:bgIv];
        [bgIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(theView);
        }];
        _thePlayControlView = theView;
    }
    return _thePlayControlView;
}
- (UIButton * )theFirstCoinButton{
    if (!_theFirstCoinButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.thePlayControlView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SF_Float(130));
            make.centerY.equalTo(self.thePlayControlView);
            make.leading.equalTo(self.thePlayControlView);
            make.trailing.mas_equalTo(self.thePlayControlView.mas_centerX);
        }];
        [theView setTitle:[NSString stringWithFormat:@"1%@", ZCLocal(@"币")] forState:UIControlStateNormal];
        theView.titleLabel.font = AutoMediumPxFont(38);
        [theView setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onPushCoinPress:) forControlEvents:UIControlEventTouchUpInside];
        theView.tag = 1;
        _theFirstCoinButton = theView;
        
        UIView *lineView = [[UIView alloc] init];
        [theView addSubview:lineView];
        lineView.backgroundColor = UIColor.whiteColor;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(theView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(1);
            make.trailing.mas_equalTo(theView.mas_trailing);
        }];

    }
    return _theFirstCoinButton;
}
- (UIButton * )theSectionCoinButton {
    if (!_theSectionCoinButton) {
        UIButton * theView = [[UIButton alloc] init];
        [self.thePlayControlView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SF_Float(130));
            make.leading.mas_equalTo(self.thePlayControlView.mas_centerX);
            make.centerY.equalTo(self.thePlayControlView);
            make.trailing.equalTo(self.thePlayControlView);
        }];
//        [theView setBackgroundImage:[PPImageUtil imageNamed:@"ico_push_coin"] forState:UIControlStateNormal];
        [theView setTitle:[NSString stringWithFormat:@"3%@", ZCLocal(@"币")] forState:UIControlStateNormal];
        theView.titleLabel.font = AutoMediumPxFont(38);
        [theView setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [theView addTarget:self action:@selector(onPushCoinPress:) forControlEvents:UIControlEventTouchUpInside];
        theView.tag = 3;
        _theSectionCoinButton = theView;
    }
    return _theSectionCoinButton;
}
- (PPCountDownView * )theCountDownView{
    if (!_theCountDownView) {
        PPCountDownView * theView = [[PPCountDownView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.thePlayControlView.mas_centerY);
            make.right.equalTo(self).offset(-SF_Float(40));
            make.size.mas_equalTo(theView.frame.size);
        }];
        theView.backgroundColor = RGBACOLOR(243, 115, 109, 1);
        theView.layer.cornerRadius = 5;
        _theCountDownView = theView;
    }
    return _theCountDownView;
}

@end

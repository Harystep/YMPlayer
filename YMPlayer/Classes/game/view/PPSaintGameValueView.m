#import "PPSaintGameValueView.h"
#import "AppDefineHeader.h"
#import "UIColor+MCUIColorsUtils.h"
#import "Masonry.h"
#import "UICountingLabel.h"
#import "PPImageUtil.h"

#import "AppDefineHeader.h"

#define minWidth 100
@interface PPSaintGameValueView ()
@property (nonatomic, weak) UIImageView * theLogoImageView;
@property (nonatomic, weak) UICountingLabel * theValueLabel;
@property (nonatomic, weak) UIView * theGameValueBgView;
@property (nonatomic,strong) UIImageView *bgIcon;
@property (nonatomic,strong) UIImageView *addIcon;

@end
@implementation PPSaintGameValueView

- (instancetype)initWithValueType:(SDGameValueType)type
{
    self = [super init];
    if (self) {
        self.valueType = type;
        self.frame = CGRectMake(0, 0, DSize(minWidth), DSize(50));
        [self configView];
    }
    return self;
}
- (instancetype)initWithForGoldLegendValueType:(SDGameValueType)type
{
    self = [super init];
    if (self) {
        self.valueType = type;
        self.frame = CGRectMake(0, 0, DSize(minWidth), DSize(64));
        [self configView];
        
        self.theValueLabel.font = AutoMediumPxFont(30);
        if (self.valueType == SDGameValue_Coin) {
            
        }
    }
    return self;
}
#pragma mark - config
- (void)configView {
    [self bgIcon];
    [self theGameValueBgView];
    [self theLogoImageView];
    [self.theValueLabel countFromZeroTo:0];
    if (self.valueType == SDGameValue_Coin) {//img_game_point img_game_coin img_game_diamond
        self.theLogoImageView.image = [PPImageUtil imageNamed:@"push_coin_money_icon"];
    } else {
        self.theLogoImageView.image = [PPImageUtil imageNamed:@"push_coin_point_icon"];
    }
    
    [self addIcon];
}
#pragma mark - set
- (void)setGameValue:(NSInteger)gameValue {
    NSInteger currentValue = gameValue;
    _gameValue = gameValue;    
    CGSize valueSize = [[self handleLargeValue:gameValue] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.theValueLabel.font} context:nil].size;
    CGFloat valueWidth = 0;
    valueWidth = DSize(50) + DSize(20) + valueSize.width + 20;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(valueWidth);
    }];
    [self.theValueLabel countFrom:currentValue to:self.gameValue withDuration:0.3];
}

- (NSString *)handleLargeValue:(NSInteger)value {
    NSString *content;
    if(value > 100000 && value < 10000000) {
        NSInteger num = value;
        content = [NSString stringWithFormat:@"%.fk", num/1000.0];
    } else if(value >= 10000000) {
        NSInteger num = value;
        content = [NSString stringWithFormat:@"%.2f亿", num/100000000.0];
    } else {
        content = [NSString stringWithFormat:@"%tu", value];
    }
    return content;
}

#pragma mark - lazy UI
- (UIImageView * )theLogoImageView{
    if (!_theLogoImageView) {
        UIImageView * theView = [[UIImageView alloc] initWithImage:[PPImageUtil imageNamed:@"ico_saint_coin"]];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self);
            make.width.and.height.mas_equalTo(DSize(50));
        }];
        _theLogoImageView = theView;
    }
    return _theLogoImageView;
}

- (UIView *)theGameValueBgView{
    if (!_theGameValueBgView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(DSize(10));
            make.right.equalTo(self).inset(20);
            if (self.valueType == SDGameValue_Coin) {
                make.centerY.equalTo(self);
            } else {
                make.top.equalTo(self).offset(DSize(13));
            }
            make.height.mas_equalTo(DSize(36));
        }];
        _theGameValueBgView = theView;
    }
    return _theGameValueBgView;
}
- (UICountingLabel * )theValueLabel{
    if (!_theValueLabel) {
        UICountingLabel * theView = [[UICountingLabel alloc] init];
        [self.theGameValueBgView addSubview:theView];
        CGFloat marginY = 0.0;
        if(self.valueType) {//积分
            marginY = -3;
        }
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.theGameValueBgView).offset(marginY);
            make.right.equalTo(self.theGameValueBgView).offset(-5);
            make.leading.mas_equalTo(self.theLogoImageView.mas_trailing).offset(2);
        }];
        theView.font = [UIFont fontWithName:@"Alfa Slab One" size:13];
        theView.textColor = [UIColor whiteColor];
        theView.format = @"%ld";
        _theValueLabel = theView;
    }
    return _theValueLabel;
}

- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc] init];
        _bgIcon.image = [PPImageUtil imageNamed:@"push_coin_money_bg"];
        [self addSubview:_bgIcon];
        [_bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return _bgIcon;
}

- (UIImageView *)addIcon {
    if (!_addIcon) {
        _addIcon = [[UIImageView alloc] init];
        _addIcon.image = [PPImageUtil imageNamed:@"push_coin_add"];
        [self addSubview:_addIcon];
        [_addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.trailing.mas_equalTo(self).inset(2);
            make.width.height.mas_equalTo(17);
        }];
    }
    return _addIcon;
}

@end

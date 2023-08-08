//
//  SJRechangeHorAlertView.m
//  YMPlayer
//
//  Created by oneStep on 2023/8/8.
//

#import "SJRechangeHorAlertView.h"
#import "SJPCChargeListRequestModel.h"

#import "PPUserInfoService.h"

#import "SJPCChargeListResponseModel.h"

#import "Masonry.h"

#import "SDRechargeUnitDataModel.h"

#import "SDRechargeUnitCollectionViewCell.h"
#import "UIColor+MCUIColorsUtils.h"
#import "PPImageUtil.h"

#import "SDRechargeUnitCycleCollectionViewCell.h"
#import "PPApplePayModule.h"
#import "UIView+Toast.h"
#import "AppDefineHeader.h"

#import "PPChargeUnitModel.h"

#import "SJPCChargeRequestModel.h"

#import "PPChargeOtherPayResponseModel.h"

#import "MBProgressHUD.h"

#import <WebKit/WebKit.h>

#import "SJChargeCardRequestModel.h"

#import "PPApplePayModule.h"

#import "SDRechargeWebViewController.h"
#import "PPChargetCoinData.h"
#import "SJRechargeCoinCollectionViewCell.h"
#import "SJPCChargeCoinByAppleCheckRequestModel.h"
#import "SJRequestAppleCreateOrderModel.h"
#import "SJResponseAppleCreateOrderModel.h"
#import "SJPCPMPointRequestModel.h"
#import "PPChargetCoinCollectionViewCell.h"

@interface SJRechangeHorAlertView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, WKNavigationDelegate>

@property (nonatomic, weak) UIView *theChargetContentView;

@property (nonatomic, weak) UICollectionView * theCollectionView;

@property (nonatomic,strong) UIButton *theCloseButton;

@property (nonatomic,strong) UIImageView *theChargeBgImageView;

@property (nonnull, nonatomic, strong) NSMutableArray<PPChargetCoinData * >* dataList;

//@property (nonatomic, strong) NSMutableArray<SDRechargeUnitDataModel *> * weekDataList;

@property (nonatomic, strong) PPApplePayModule * applePayModule;
@property (nonatomic,strong) UILabel *theTitleLabel;
@property (nonatomic, weak) WKWebView * theWebView;

@end

@implementation SJRechangeHorAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    self.alpha = 1;
    [self configView];
    [self configData];
    
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)configData {
    
    self.applePayModule = [PPApplePayModule sharedInstance];
    
    self.dataList = [NSMutableArray array];
    SJPCPMPointRequestModel * requestModel = [[SJPCPMPointRequestModel alloc] init];
    requestModel.accessToken = [PPUserInfoService get_Instance].access_token;
    [requestModel requestFinish:^(__kindof PPResponseBaseModel * _Nullable responseModel, PPError * _Nullable error) {
        if (!error) {
            SJPmPointResponseModel * response = responseModel;
            SDPMPointChargeInfo * pmChargeInfo = response.data;
            NSArray * chargeList = pmChargeInfo.list;
            NSMutableArray * list = [NSMutableArray arrayWithCapacity:0];
            for (SDPmPointUnitDataModel * model in chargeList) {
                [list addObject: [[PPChargetCoinData alloc] initWithPmPointData:model]];
            }
            self.dataList = [list copy];
            [self.theCollectionView reloadData];
        }
    }];
}

- (NSInteger)convertPayTypeWithData:(NSArray *)option {
    NSInteger type = 3;
    for (NSDictionary *dic in option) {
        if([dic[@"payMode"] integerValue] == 3) {//
            type = 3;
            break;
        } else {
            type = 2;
        }
    }
    return type;
}

- (void)configView {
    [self theChargetContentView];
    [self theChargeBgImageView];
    [self theTitleLabel];
    [self coinDataView];
    [self theCloseButton];
}
#pragma mark - action
- (void)onCloseBarPress {
    [self onDissmissContentView];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPChargetCoinCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PPChargetCoinCollectionViewCell" forIndexPath:indexPath];
    PPChargetCoinData * data = self.dataList[indexPath.row];
    [cell loadCoinModel:data];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    PPChargetCoinData *model = self.dataList[indexPath.row];
    if([self.delegate respondsToSelector:@selector(rechangePointData:)]) {
        [self.delegate rechangePointData:model];
    }
}

- (void)onDissmissContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if([self.delegate respondsToSelector:@selector(dissmissRechangeController)]) {
        [self.delegate dissmissRechangeController];
    }
}

- (void)showLoading {
  [MBProgressHUD showHUDAddedTo:self animated:true];
}
- (void)hideLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:true];
    });
}

#pragma mark - lazy UI
- (UICollectionView *)theCollectionView{
    if (!_theCollectionView) {
        UICollectionViewFlowLayout * flowLayot = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayot];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.theChargetContentView).inset(12);
            make.bottom.mas_equalTo(self.theChargetContentView.mas_bottom).inset(5);
            make.top.mas_equalTo(self.coinDataView.mas_bottom).offset(10);
        }];
        flowLayot.itemSize = CGSizeMake(145, DSize(292));
        theView.dataSource = self;
        theView.delegate = self;
        theView.showsVerticalScrollIndicator = NO;
        theView.backgroundColor = UIColor.clearColor;
        theView.contentInset = UIEdgeInsetsMake(0, 4, 0, 4);
        [theView registerClass:[PPChargetCoinCollectionViewCell class] forCellWithReuseIdentifier:@"PPChargetCoinCollectionViewCell"];
        _theCollectionView = theView;
    }
    return _theCollectionView;
}

- (SJUserRechargeCoinDataView *)coinDataView {
    if (!_coinDataView) {
        _coinDataView = [[SJUserRechargeCoinDataView alloc] init];
        [self.theChargetContentView addSubview:_coinDataView];
        [_coinDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.theChargetContentView.mas_centerX);
            make.top.mas_equalTo(self.theChargetContentView.mas_top).offset(DSize(118));
            make.width.mas_equalTo(DSize(520));
        }];
    }
    return _coinDataView;
}

- (UILabel *)theTitleLabel {
    if (!_theTitleLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.theChargetContentView);
            make.top.equalTo(self.theChargetContentView).offset(SF_Float(44));
        }];
        theView.textColor = [UIColor whiteColor];
        theView.font = AutoBoldPxFont(36);
        theView.text = ZCLocal(@"兑换中心");
        _theTitleLabel = theView;
    }
    return _theTitleLabel;
}

#pragma mark - lazy
- (UIView * )theChargetContentView{
    if (!_theChargetContentView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(335);
            make.height.mas_equalTo(550);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        _theChargetContentView = theView;
        
    }
    return _theChargetContentView;
}

- (UIButton * )theCloseButton{
    if (!_theCloseButton) {
        UIButton * theView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.theChargetContentView addSubview:theView];
        [theView setImage:[PPImageUtil imageNamed:@"ico_game_close"] forState:UIControlStateNormal];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.theChargetContentView);
            make.right.equalTo(self.theChargetContentView);
            make.width.and.height.mas_equalTo(SF_Float(100));
        }];
        theView.tintColor = [UIColor blackColor];
        [theView addTarget:self action:@selector(onDissmissContentView) forControlEvents:UIControlEventTouchUpInside];
        _theCloseButton = theView;
    }
    return _theCloseButton;
}

- (UIImageView * )theChargeBgImageView{
    if (!_theChargeBgImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.theChargetContentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.theChargetContentView);
        }];
        theView.image = [PPImageUtil imageNamed:@"img_game_alert_coin_bg_ver_a"];
        _theChargeBgImageView = theView;
    }
    return _theChargeBgImageView;
}

@end

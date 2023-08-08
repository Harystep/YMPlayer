//
//  SJRechangeHorAlertView.h
//  YMPlayer
//
//  Created by oneStep on 2023/8/8.
//

#import <UIKit/UIKit.h>
#import "SJUserRechargeCoinDataView.h"
@class PPChargetCoinData;

NS_ASSUME_NONNULL_BEGIN

@protocol SJRechangeHorAlertViewDelegate <NSObject>
- (void)dissmissRechangeController;
- (void)showChargeAliPayViewData:(NSString *)data;
- (void)payPointSuccessStatus;
- (void)rechangePointData:(PPChargetCoinData *)data;
@end

@interface SJRechangeHorAlertView : UIView

@property (nonatomic,strong) SJUserRechargeCoinDataView *coinDataView;

@property (nonatomic, weak) id<SJRechangeHorAlertViewDelegate> delegate;

- (void)showChargeAliPayWebView:(NSString *)data;

@end

NS_ASSUME_NONNULL_END

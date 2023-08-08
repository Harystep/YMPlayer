
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SJUserMoneyDataViewDelegate <NSObject>

- (void)consumeTypeWithTag:(NSInteger)tag;

@end

@interface SJUserMoneyDataView : UIView

@property (nonatomic,copy) NSString *priceValue;//
@property (nonatomic,copy) NSString *pointValue;//

@property (nonatomic,weak) id<SJUserMoneyDataViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

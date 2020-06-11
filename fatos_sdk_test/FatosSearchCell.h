//
//  FatosSearchCell.h
//  Fatos
//
//  Created by 심규빈 on 2020/02/10.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FatosSearchCellDelegate <NSObject>
- (void) selectSearchItem:(NSDictionary *)item;
@end

@interface FatosSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cell;
@property (weak, nonatomic) IBOutlet UILabel *addressName1;
@property (weak, nonatomic) IBOutlet UILabel *addressName2;

- (IBAction) cellClick:(id)sender;
- (void) setItem:(NSDictionary *)item;

@property(strong, nonatomic) id<FatosSearchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

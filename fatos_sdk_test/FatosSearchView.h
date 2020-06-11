//
//  FatosSearchView.h
//  Fatos
//
//  Created by 심규빈 on 2020/02/10.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FatosSearchView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) setSearchData:(NSMutableDictionary *)pSearchDic;
- (void) setSearchCellClickDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END

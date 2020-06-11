//
//  FatosSearchView.m
//  Fatos
//
//  Created by 심규빈 on 2020/02/10.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import "FatosSearchView.h"
#import "FatosSearchCell.h"
#import <FatosUtil.h>

@interface FatosSearchView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FatosSearchView
{
    NSMutableDictionary *searchDic;
    NSBundle *resourcebundle;
    NSArray *items;
    id searchCellClickDelegate;
}

- (void) setSearchData:(NSMutableDictionary *)pSearchDic
{
    if(pSearchDic == nil)
        return;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    resourcebundle = [FatosUtil getResourcebundle];
    searchDic = pSearchDic;
    
    
    if(searchDic != nil)
    {
        items = [searchDic valueForKey:@"items"];
        [_tableView reloadData];
    }
}

- (void) setSearchCellClickDelegate:(id)clickDelegate
{
    searchCellClickDelegate = clickDelegate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"searchcell";
    FatosSearchCell *cell = (FatosSearchCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil)
    {
        cell = [[resourcebundle loadNibNamed:identifier owner:nil options:nil] lastObject];
        cell.delegate = searchCellClickDelegate;
        [cell setItem:[items objectAtIndex:indexPath.row]];
    }
    
    return cell;
}




@end

//
//  FatosSearchCell.m
//  Fatos
//
//  Created by 심규빈 on 2020/02/10.
//  Copyright © 2020 유춘성. All rights reserved.
//

#import "FatosSearchCell.h"
#import <FatosUtil.h>

@implementation FatosSearchCell
{
    NSDictionary *m_Item;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _cell.layer.cornerRadius = 5;
    _cell.layer.borderWidth = 0.5f;
    _cell.layer.borderColor = [UIColor blackColor].CGColor;
    
    m_Item = nil;
    _delegate = nil;
}

- (IBAction) cellClick:(id)sender
{
    if(_delegate != nil)
    {
        [_delegate selectSearchItem:m_Item];
    }
}

- (void) setItem:(NSDictionary *)item
{
    m_Item = item;
    
    if(m_Item != nil)
    {
        _addressName1.text = [FatosUtil getStringValue:[item valueForKey:@"name"]];
        _addressName2.text = [FatosUtil getStringValue:[item valueForKey:@"addr2"]];
    }
}

@end

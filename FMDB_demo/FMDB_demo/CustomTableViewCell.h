//
//  CustomTableViewCell.h
//  FMDB_demo
//
//  Created by xx on 16/11/16.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deleteBlock)();

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (copy, nonatomic) deleteBlock deleteblock;

@end

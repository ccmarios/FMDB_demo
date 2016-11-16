//
//  AddMessageViewController.h
//  FMDB_demo
//
//  Created by xx on 16/11/16.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^commitBlock)();

@interface AddMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (copy, nonatomic) commitBlock commitblock;

@end

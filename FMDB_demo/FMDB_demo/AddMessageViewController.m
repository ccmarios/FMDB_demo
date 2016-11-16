//
//  AddMessageViewController.m
//  FMDB_demo
//
//  Created by xx on 16/11/16.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import "AddMessageViewController.h"

@interface AddMessageViewController ()<UITextFieldDelegate>

@end

@implementation AddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"添加信息"];
    self.nameTextField.delegate = self;
    self.ageTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)commitButton:(id)sender {
    NSDictionary *dic = @{@"name":self.nameTextField.text,@"age":self.ageTextField.text};
    [[DBHandler sharedInstance] historyInsertDic:dic];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.commitblock) {
        self.commitblock();
    }
}

@end

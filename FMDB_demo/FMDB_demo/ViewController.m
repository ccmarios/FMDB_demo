//
//  ViewController.m
//  FMDB_demo
//
//  Created by xx on 16/11/16.
//  Copyright © 2016年 d.d. All rights reserved.
//

#import "ViewController.h"
#import "AddMessageViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view addSubview:self.tableView];
    
    //数据库
    [[DBHandler sharedInstance] createDB];
    self.dataSource = [[DBHandler sharedInstance]gethistoryInfoList];
}

- (void)initNavigation{
    [self.navigationItem setTitle:@"FMDB"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(addMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)addMessage{
    AddMessageViewController *addVC = [[AddMessageViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
    
    WS(weakSelf);
    [addVC setCommitblock:^(){
        weakSelf.dataSource = [[DBHandler sharedInstance]gethistoryInfoList];
        [weakSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",[self.dataSource[indexPath.row] objectForKey:@"name"]];
    cell.ageLabel.text = [NSString stringWithFormat:@"年龄:%@",[self.dataSource[indexPath.row] objectForKey:@"age"]] ;
    
    WS(weakSelf);
    [cell setDeleteblock:^(){
        [[DBHandler sharedInstance] deleteInfoWithName:[weakSelf.dataSource[indexPath.row] objectForKey:@"name"]];
        weakSelf.dataSource = [[DBHandler sharedInstance]gethistoryInfoList];
        [weakSelf.tableView reloadData];
    }];
    
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:0xf7 green:0xf7 blue:0xf7 alpha:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end

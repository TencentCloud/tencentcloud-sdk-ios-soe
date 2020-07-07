//
//  TableViewController.m
//  TAIDemo
//
//  Created by kennethmiao on 2019/1/17.
//  Copyright © 2019年 kennethmiao. All rights reserved.
//

#import "TableViewController.h"
#import <TAISDK/TAIManager.h>

@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *tabs;
@end

@implementation TabInfo
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"教育AI（%@）",[TAIManager getVersion]];
    _tabs = [NSMutableArray array];
    
    TabInfo *math = [[TabInfo alloc] init];
    math.title = @"数学批改";
    math.className = @"MathCorrectionViewController";
    [_tabs addObject:math];
    
    
    TabInfo *oral = [[TabInfo alloc] init];
    oral.title = @"口语评测";
    oral.className = @"OralEvaluationViewController";
    [_tabs addObject:oral];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tabs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    TabInfo *tab = _tabs[indexPath.row];
    cell.textLabel.text = tab.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TabInfo *tab = _tabs[indexPath.row];
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:tab.className];
    [self.navigationController pushViewController:controller animated:YES];
    
}
@end

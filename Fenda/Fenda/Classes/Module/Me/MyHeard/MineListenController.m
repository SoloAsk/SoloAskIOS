//
//  MineListenController.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineListenController.h"
#import "MineListenCell.h"
#import "QuestionDetailController.h"
#import "MineListenHeadView.h"
#import "NoQandAController.h"

@interface MineListenController ()

@property (nonatomic,strong) MineListenCell *listenCell;

@end

@implementation MineListenController

static NSString *reuseIdentifier = @"MineListenCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我听", "");
    
    
    self.shareItem.hidden = YES;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"MineListenCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.listenCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineListenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return [[MineListenHeadView alloc] init];
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionDetailController *quesVC = [[QuestionDetailController alloc] init];
    quesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:quesVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.listenCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 46;
    }
    
    return 0;
}




@end

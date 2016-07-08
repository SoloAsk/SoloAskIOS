//
//  MineAnswerController.m
//  Fenda
//
//  Created by zhiwei on 16/6/28.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "MineAnswerController.h"
#import "MineAskCell.h"
#import "MinAnswerHeadView.h"
#import "AnswerVoiceController.h"

@interface MineAnswerController ()

@property (nonatomic,strong) MineAskCell *mineAskCell;

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation MineAnswerController

static NSString *reuseIdentifier = @"mineAskCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我答", "");
    
    self.shareItem.hidden = YES;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MineAskCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.mineAskCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineAskCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //    cell.mineAskModel = self.data[indexPath.section];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = [self.mineAskCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectIndex == 0) {
        
        AnswerVoiceController *answerVC = [[AnswerVoiceController alloc] init];
        answerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:answerVC animated:YES];
        
    }else{
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //头部
    if (section == 0) {
        MinAnswerHeadView *headView = [[MinAnswerHeadView alloc] init];
        
        return headView;
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 46;
    }
    
    return 0;
}

@end

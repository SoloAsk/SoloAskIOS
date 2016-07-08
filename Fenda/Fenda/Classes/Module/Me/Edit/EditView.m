//
//  EditView.m
//  Fenda
//
//  Created by zhiwei on 16/6/29.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "EditView.h"
#import "zySheetPickerView.h"
#import "IQTextView.h"

@interface EditView()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet IQTextView *honorLabel;
@property (weak, nonatomic) IBOutlet IQTextView *introduce;

@end

@implementation EditView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.introduce.placeholder = NSLocalizedString(@"About these, enjoy ask me; financial investment, won the white Formica; how elegant in former wedding; the opposite sex and travel to the impulse to self management... Or give you sing goodnight ditty", "");
    self.honorLabel.placeholder = NSLocalizedString(@"Operations Manager DJ Google; radio; early employees; round slash youth; Counselor", "");
    
    self.userIcon.layer.cornerRadius = self.userIcon.bounds.size.width/2;
    self.userIcon.clipsToBounds = YES;
    
    self.saveBtn.layer.cornerRadius = 5;
    self.saveBtn.clipsToBounds = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"EditView" owner:nil options:nil].lastObject;
    }
    return self;
}


- (IBAction)priceBtnClick:(UIButton *)sender {
    
    NSArray * str  = @[@"$1",@"$2",@"$3",@"$4",@"$5",@"$6",@"$7",@"$8",@"$9",@"$10"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"Select Price" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        [self.priceBtn setTitle:choiceString forState:UIControlStateNormal];
        [pickerView dismissPicker];
    }];
    [pickerView show];
}





@end

//
//  PlayAnimation.m
//  Fenda
//
//  Created by zhiwei on 16/6/14.
//  Copyright © 2016年 zhiwei. All rights reserved.
//

#import "PlayAnimation.h"

@implementation PlayAnimation
static UIImageView *playIcon;


+ (void)runAnimationWithCount:(int)count AndImageView:(UIImageView *)playImge{
    
    playIcon = playImge;
    
    if (playIcon.isAnimating) {
        return;
    }
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 1; i<= count;  i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"fanta_ic_playing_%d.png",i];
        
        NSLog(@"%@",imageName);
        
        NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
        UIImage *image =  [UIImage imageWithContentsOfFile:path];
        [images addObject:image];
        
    }
    
    playIcon.animationImages = images;
    
    
   playIcon.animationRepeatCount = 6;
    
    CGFloat eachDuration = 0.2;
    playIcon.animationDuration = eachDuration * images.count;
    [playIcon startAnimating];
    
    [self performSelector:@selector(clearCache) withObject:nil afterDelay:playIcon.animationDuration + 0.2];
}

+ (void)clearCache{
    playIcon.animationImages = nil;
}




@end

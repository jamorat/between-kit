//
//  UIView+I3Collection.m
//  Pods
//
//  Created by Stephen Fortune on 17/11/2014.
//
//

#import "UIView+I3Collection.h"


@implementation UIView (I3Collection)


#pragma mark - I3Collection implementation


-(UIView *)collectionView{
    return self;
}


-(UIView *)itemAtPoint:(CGPoint) at{
    
    UIView *subview = nil;
    
    for(UIView *view in self.subviews){
        CGPoint localAt = [self convertPoint:at toView:view];
        NSLog(@"Testing whether %@ is in %@", NSStringFromCGPoint(localAt), NSStringFromCGRect(view.frame));
        if([view pointInside:localAt withEvent:nil]){
            NSLog(@"It is !");
            subview = view;
            break;
        }
    }
    
    return subview;
}


@end
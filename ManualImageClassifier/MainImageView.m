//
//  MainImageView.m
//  ManualImageClassifier
//
//  Created by Samuel Mueller on 08.05.16.
//  Copyright © 2016 MullerMuller. All rights reserved.
//

#import "MainImageView.h"

@implementation MainImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.

}
-(BOOL)acceptsFirstResponder{
    return NO;
}

-(void)keyUp:(NSEvent *)theEvent{
    NSLog(@"Character: %@",[theEvent characters]);
}

@end

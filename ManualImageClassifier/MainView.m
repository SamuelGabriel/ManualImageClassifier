//
//  MainView.m
//  ManualImageClassifier
//
//  Created by Samuel Mueller on 08.05.16.
//  Copyright © 2016 MullerMuller. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    
}
-(BOOL)acceptsFirstResponder{
    return YES;
}

-(void)keyDown:(NSEvent *)theEvent{
    NSLog(@"Character: %@",[theEvent characters]);
}


@end

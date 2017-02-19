//
//  ViewController.h
//  coBlue_iOS
//
//  Created by huke on 2/14/17.
//  Copyright (c) 2017 com.cocoahuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include "coblue_control.h"

extern void objc_msgSend1( id self, SEL op, ...  );
extern BOOL execute_done;

#define DEBUG_IN_IPHONE_SIMULATOR 0
#define COBLUE_PROMPT "[coblue server]#  "

#define printf(X,...) do{dispatch_async(dispatch_get_main_queue(), ^{ \
    [[ViewController singleton] Print2textView:[NSString stringWithFormat:@X,##__VA_ARGS__]]; \
});}while(0)

#define print_prompt do{dispatch_async(dispatch_get_main_queue(), ^{ \
    [[ViewController singleton]textViewPrintPrompt]; \
});}while(0)


@interface ViewController : UIViewController <UITextViewDelegate>
+(id)singleton;
-(void)coBlue_updateConnectStep:(int)i;
-(void)Print2textView:(NSString*)str;
-(void)terminal_quit;
-(void)textViewPrintPrompt;

+(CGFloat)fontsize:(CGFloat)stdsize;
@end


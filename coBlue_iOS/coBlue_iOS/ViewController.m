//
//  ViewController.m
//  coBlue_iOS
//
//  Created by huke on 2/14/17.
//  Copyright (c) 2017 com.cocoahuke. All rights reserved.
//

#import "ViewController.h"
#include <dlfcn.h>
#include <objc/runtime.h>

void (*OBJC_MSGSEND)(id self, SEL op, id arg ) = NULL;
/*Variable parameters seem cannot pass on my phone, but work on simulator*/

BOOL execute_done = NO;

char gotoSetting_key[3];

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface  SquareView: UIView
@property(nonatomic,readwrite) BOOL continuePlay;
-(void)play_animation_tada;
-(void)play_animation_shake;
@end
@implementation SquareView

-(instancetype)initWithFrame:(CGRect)frame{
    self.userInteractionEnabled = NO;
    self.continuePlay = NO;
    return [super initWithFrame:frame];
}

CGFloat degreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

-(void)play_animation_tada
{
    float dist = 0.5;
    float dur = 0.09;
    [UIView animateWithDuration:dur animations:^{
        CGAffineTransform rotationTransform = CGAffineTransformMakeScale(0.95, 0.95);
        rotationTransform = CGAffineTransformRotate(rotationTransform, degreesToRadians(dist));
        self.transform = rotationTransform;
    } completion:^(BOOL f){
        [UIView animateWithDuration:dur animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformMakeScale(1.05, 1.05);
            rotationTransform = CGAffineTransformRotate(rotationTransform, degreesToRadians(-dist));
            self.transform = rotationTransform;
        } completion:^(BOOL f){
            
            [UIView animateWithDuration:dur animations:^{
                CGAffineTransform rotationTransform = self.transform;
                self.transform = CGAffineTransformRotate(rotationTransform, degreesToRadians(dist*2));
            } completion:^(BOOL f){
                [UIView animateWithDuration:dur animations:^{
                    CGAffineTransform rotationTransform = self.transform;
                    self.transform = CGAffineTransformRotate(rotationTransform, degreesToRadians(-dist*2));
                } completion:^(BOOL f){
                    [UIView animateWithDuration:dur animations:^{
                        CGAffineTransform rotationTransform = self.transform;
                        self.transform = CGAffineTransformRotate(rotationTransform, degreesToRadians(dist*2));
                    } completion:^(BOOL f){
                        [UIView animateWithDuration:dur animations:^{
                            CGAffineTransform rotationTransform = self.transform;
                            self.transform = CGAffineTransformRotate(rotationTransform, degreesToRadians(-dist*2));
                        } completion:^(BOOL f){
                            [UIView animateWithDuration:dur animations:^{
                                CGAffineTransform rotationTransform = CGAffineTransformMakeScale(1, 1);
                                rotationTransform = CGAffineTransformRotate(rotationTransform, degreesToRadians(0));
                                self.transform = rotationTransform;
                            } completion:^(BOOL f){
                                if(self.continuePlay){
                                    [self play_animation_tada];
                                }
                            }];
                        }];
                    }];
                }];
            }];
            
        }];
    }];
}

typedef void (^DCAnimationFinished)(void);

-(void)setX:(CGFloat)x duration:(NSTimeInterval)time finished:(DCAnimationFinished)finished
{
    [UIView animateWithDuration:time animations:^{
        CGRect frame = self.frame;
        frame.origin.x = x;
        self.frame = frame;
    } completion:^(BOOL f){
        if(finished)
            finished();
    }];
}

-(void)moveX:(CGFloat)x duration:(NSTimeInterval)time finished:(DCAnimationFinished)finished
{
    [self setX:(self.frame.origin.x+x) duration:time finished:finished];
}

-(void)play_animation_shake{
    NSTimeInterval dur = 0.08;
    float dist = 1;
    [self moveX:-dist duration:dur finished:^{
        [self moveX:dist*2 duration:dur finished:^{
            [self moveX:-(dist*2) duration:dur finished:^{
                [self moveX:dist duration:dur finished:^{
                    if(self.continuePlay){
                        [self play_animation_shake];
                    }
                }];
            }];
        }];
    }];
}

@end

@interface SettingView : UIView<UITextFieldDelegate>
@end

@implementation SettingView
{
    UITextField *devNameTF;
    UITextField *authKeyTF;
}

-(UITextField*)getTextFildwithConfig:(CGFloat)DofScreenHeight labText:(NSString*)labText{
    UILabel *toplab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/1.3, SCREEN_HEIGHT/19)];
    toplab.font = [UIFont fontWithName:@"Menlo" size:[ViewController fontsize:19]];
    toplab.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/DofScreenHeight);
    toplab.text = labText;
    toplab.textColor = [UIColor colorWithRed:240/255.0 green:177/250.0 blue:53/255.0 alpha:1];
    [self addSubview:toplab];
    toplab.textAlignment = NSTextAlignmentCenter;
    UITextField *onetf = [[UITextField alloc]initWithFrame:CGRectMake(0, toplab.frame.origin.y+toplab.frame.size.height, SCREEN_WIDTH/1.3, SCREEN_HEIGHT/12)];
    onetf.center = CGPointMake(SCREEN_WIDTH/2, onetf.center.y);
    onetf.font = [UIFont fontWithName:@"Menlo" size:[ViewController fontsize:19]];
    onetf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    onetf.autocorrectionType = UITextAutocorrectionTypeNo;
    onetf.textColor = [UIColor whiteColor];
    onetf.layer.borderColor = [UIColor whiteColor].CGColor;
    onetf.layer.borderWidth = 1.5;
    onetf.delegate = self;
    [self addSubview:onetf];
    return onetf;
}

-(void)actForApply{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:devNameTF.text forKey:@"DeviceName"];
    [userDefaultes setObject:authKeyTF.text forKey:@"VerifyKey"];
    [userDefaultes synchronize];
    [self actForBack];
}

-(void)actForBack{
    [self removeFromSuperview];
}

-(void)OurApplyAndBack:(CGFloat)DofScreenHeight{
    UIButton *apyB = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/1.3, SCREEN_HEIGHT/19)];
    [apyB addTarget:self action:@selector(actForApply) forControlEvents:UIControlEventTouchUpInside];
    apyB.backgroundColor = [UIColor whiteColor];
    [apyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [apyB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    apyB.titleLabel.font = [UIFont fontWithName:@"Menlo" size:[ViewController fontsize:19]];
    apyB.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/DofScreenHeight);
    [apyB setTitle:@"Apply" forState:UIControlStateNormal];
    [self addSubview:apyB];
    
    UIButton *bacB = [[UIButton alloc]initWithFrame:CGRectMake(0, apyB.frame.origin.y+(apyB.frame.size.height*2), SCREEN_WIDTH/1.3, SCREEN_HEIGHT/19)];
    [bacB addTarget:self action:@selector(actForBack) forControlEvents:UIControlEventTouchUpInside];
    bacB.backgroundColor = [UIColor whiteColor];
    [bacB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bacB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    bacB.titleLabel.font = [UIFont fontWithName:@"Menlo" size:[ViewController fontsize:19]];
    bacB.center = CGPointMake(SCREEN_WIDTH/2, bacB.center.y);
    [bacB setTitle:@"Back" forState:UIControlStateNormal];
    [self addSubview:bacB];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(instancetype)initSettingView{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *saved_name = [userDefaultes stringForKey:@"DeviceName"];
    NSString *saved_key = [userDefaultes stringForKey:@"VerifyKey"];
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backgroundColor = [UIColor blackColor];
    devNameTF = [self getTextFildwithConfig:13 labText:@"coBlue Device name"];
    devNameTF.text = saved_name;
    authKeyTF = [self getTextFildwithConfig:4 labText:@"coBlue verify key"];
    authKeyTF.text = saved_key;
    
    [self OurApplyAndBack:2];
    
    return self;
}

@end

struct cmd_info {
    char *cmd;
    char *method_ptr;
    char *doc;
};

@interface ViewController ()

@end

#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
static struct cmd_info all_cmd[] = {
    { "help", "cmd_help:", "\t\tShow all availble cmds"},
    { "clear", "cmd_clear:", "\tClear the terminal screen"},
    { "quit", "cmd_quit:", "\t\tExit program"},
    { "exit", "cmd_quit:", "\t\tExit program"}
};

@implementation ViewController
{
    UIView *pView;
    SquareView *stepsView;
    UITextView *cmdTextView;
    NSUInteger typingSP;
    UITextView *typingText;
    UIView *typeCursor; BOOL stopFlashing;
}

ViewController *st_instance = NULL;
+(id)singleton{
    return st_instance;
}

-(void)cmd_help:(NSString*)cmd{
    struct cmd_info *c;
    for (int i = 0; i < NELEM(all_cmd); i++) {
        c = &all_cmd[i];
        if (c->doc)
            printf("%-2c%s%s\n", ' ', c->cmd, c->doc);
    }
    print_prompt;
}

-(void)cmd_clear:(NSString*)cmd{
    cmdTextView.text = @"";
    print_prompt;
}

-(void)cmd_quit:(NSString*)cmd{
    printf("logout\n\n");
    printf("[Process completed]\n");
}

-(void)terminal_quit{
    execute_done = NO;
    [self cmd_quit:nil];
}

-(void)prolugue{
    printf("Welcome to using coBlue simulation terminal on iOS\n");
    printf("Wrote by @cocoauhuke, 2/17/2017\n");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    st_instance = self;
    
    OBJC_MSGSEND = (typeof(OBJC_MSGSEND))dlsym(-1,"objc_msgSend");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [self initiateBackGround];
    [self initiateProgress];
    [self initiateCmdTextView];
    [self initiateTypingText];
    
    [self prolugue];
    
    memcpy(gotoSetting_key, "š", sizeof(gotoSetting_key));
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *saved_name = [userDefaultes stringForKey:@"DeviceName"];
    NSString *saved_key = [userDefaultes stringForKey:@"VerifyKey"];
    COBLUE_DEVICE_NAME = saved_name?(char*)[saved_name UTF8String]:"orange";
    COBLUE_VERIFY_KEY = saved_key?(char*)[saved_key UTF8String]:NULL;
    
    if(DEBUG_IN_IPHONE_SIMULATOR){
        printf("IN DEBUG MODE\n");
        print_prompt;
    }
    else
        coblue_initiate();
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    cmdTextView.frame = CGRectMake(cmdTextView.frame.origin.x,cmdTextView.frame.origin.y,cmdTextView.frame.size.width,SCREEN_HEIGHT-pView.frame.size.height-height-(SCREEN_HEIGHT/30));
}

-(void)initiateBackGround{
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)initiateProgress{
    pView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT/16)];
    [pView setBackgroundColor:[UIColor whiteColor]];
    
    for(int i=0;i<4;i++)
        stepsView = [self InsertSquare:i];
    
    [self.view addSubview:pView];
}


-(SquareView*)InsertSquare:(int)index{
    if([[pView subviews]count]<4){
        CGFloat sq_width = pView.frame.size.width/4.2;
        CGFloat sq_height = sq_width/6;
        
        CGFloat sq_ctr_x_offset = 0;
        CGFloat sq_ctr_y_offset = pView.frame.size.height/4;
        
        SquareView *littleSquare = [[SquareView alloc]initWithFrame:CGRectMake(0, 0, sq_width, sq_height)];
        [littleSquare setBackgroundColor:[UIColor colorWithRed:232/255.0 green:177/255.0 blue:87/255.0 alpha:1]];
        
        littleSquare.center = CGPointMake((pView.frame.size.width/4)/2+(pView.frame.size.width/4)*index+sq_ctr_x_offset, pView.frame.size.height/2+sq_ctr_y_offset);
        littleSquare.alpha = 0;
        
        /*
         i:1 x:40.000000 y:31.555556
         i:2 x:120.000000 y:31.555556
         i:3 x:200.000000 y:31.555556
         i:4 x:280.000000 y:31.555556
         */
        
        [pView addSubview:littleSquare];
        return littleSquare;
    }
    return nil;
}

-(void)coBlue_updateConnectComplete{
    for(int _i=0; _i<[[pView subviews]count]; _i++){
        SquareView *subView = [pView subviews][_i];
        subView.continuePlay = NO;
        subView.backgroundColor = [UIColor colorWithRed:43/255.0 green:192/255.0 blue:42/255.0 alpha:1];
    }
}

-(void)coBlue_updateConnectStep:(int)i{
    for(int _i=0; _i<[[pView subviews]count]; _i++){
        SquareView *subView = [pView subviews][_i];
        subView.continuePlay = YES;
    }
    if(i==4)
    {
        [self coBlue_updateConnectComplete];
        return;
    }
    
    SquareView *subView = [pView subviews][i];
    [UIView animateWithDuration:0.3 animations:^{
        subView.alpha = 1;
        //subView.center = CGPointMake(subView.center.x,-(subView.center.y));
    } completion:^(BOOL finished) {
        [subView play_animation_shake];
    }];
}


-(void)coBlue_reconnect{
    /*Abandoned*/
    for(int i=0; i<[[pView subviews]count]; i++){
        SquareView *subView = [[[pView subviews]reverseObjectEnumerator]allObjects][i];
        subView.continuePlay = YES;
        if(subView.alpha){
            
            [UIView animateWithDuration:0.3 delay:i*0.08 options:UIViewAnimationOptionCurveEaseIn animations:^{
                subView.alpha = 0;
                //subView.center = CGPointMake(subView.center.x,-(subView.center.y));
            } completion:^(BOOL finished) {
                [subView setBackgroundColor:[UIColor colorWithRed:232/255.0 green:177/255.0 blue:87/255.0 alpha:1]];
                coblue_initiate();
            }];
            
        }
    }
}

-(void)cursorStopFlashing{
    typeCursor.alpha = 0;
    stopFlashing = YES;
}

-(void)cursorStartFlashing{
    stopFlashing = NO;
}

-(void)cursorInitiateFlashing{
    [UIView animateWithDuration:0.01 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(!typeCursor.alpha&&!stopFlashing)
            typeCursor.alpha = 1;
        else
            typeCursor.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self cursorInitiateFlashing];
    }];
}

-(void)initiateCmdTextView{
    cmdTextView = [[UITextView alloc]initWithFrame:CGRectMake(0,pView.frame.size.height,SCREEN_WIDTH,SCREEN_HEIGHT-pView.frame.size.height)];
    cmdTextView.backgroundColor = [UIColor blackColor];
    cmdTextView.scrollEnabled = YES;
    cmdTextView.font = [UIFont fontWithName:@"Menlo" size:[[self class] fontsize:13]];
    cmdTextView.textColor = [UIColor colorWithRed:33/255.0 green:227/255.0 blue:18/255.0 alpha:1];
    cmdTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    cmdTextView.editable = NO;
    cmdTextView.textContainer.lineFragmentPadding = 0.0f;
    cmdTextView.textContainerInset = UIEdgeInsetsZero;
    cmdTextView.layoutManager.allowsNonContiguousLayout = NO;
    typingSP = 0;
    [self.view addSubview:cmdTextView];
    UITextRange *textrange = [cmdTextView textRangeFromPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: 0] toPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: -1]];
    typeCursor = [[UIView alloc]initWithFrame:[cmdTextView firstRectForRange:textrange]];
    typeCursor.backgroundColor = [UIColor colorWithRed:33/255.0 green:227/255.0 blue:18/255.0 alpha:1];
    stopFlashing = NO;
    [self cursorInitiateFlashing];
    [cmdTextView addSubview:typeCursor];
}

+(CGFloat)fontsize:(CGFloat)stdsize{
    if(SCREEN_HEIGHT==568.0f)
        return stdsize;
    if(SCREEN_HEIGHT==667.0f)
        return stdsize+2.0;
    if(SCREEN_HEIGHT==736.0f)
        return stdsize+3.0;
    return 0;
}

-(void)initiateTypingText{
    typingText = [[UITextView alloc]initWithFrame:CGRectMake(0,0,50,50)];
    typingText.alpha = 0;
    typingText.backgroundColor = [UIColor redColor];
    typingText.autocorrectionType = UITextAutocorrectionTypeNo;
    typingText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    typingText.delegate = self;
    typingText.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.view addSubview:typingText];
    [typingText becomeFirstResponder];
}

-(void)Print2textView:(NSString*)str{
    [self cursorStopFlashing];
    
    if(!cmdTextView.text.length)
        cmdTextView.text = [cmdTextView.text stringByAppendingString:str];
    
    else if(cmdTextView.text.length){
        CGRect lastCharRect = [cmdTextView firstRectForRange:[cmdTextView textRangeFromPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: 0] toPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: -1]]];
        if(typeCursor.frame.origin.x==lastCharRect.origin.x&&typeCursor.frame.origin.y==lastCharRect.origin.y)
            cmdTextView.text = [[cmdTextView.text substringToIndex:cmdTextView.text.length-1] stringByAppendingString:str];
        else
            cmdTextView.text = [cmdTextView.text stringByAppendingString:str];
    }
    
    [cmdTextView scrollRangeToVisible:NSMakeRange(cmdTextView.text.length, 1)];
}

-(void)textViewPrintPrompt{
    if(!cmdTextView.text.length)
        cmdTextView.text = [cmdTextView.text stringByAppendingString:[[NSString stringWithUTF8String:COBLUE_PROMPT] substringToIndex:strlen(COBLUE_PROMPT)-1]];
    else if(cmdTextView.text.length){
        CGRect lastCharRect = [cmdTextView firstRectForRange:[cmdTextView textRangeFromPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: 0] toPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: -1]]];
        if(typeCursor.frame.origin.x==lastCharRect.origin.x&&typeCursor.frame.origin.y==lastCharRect.origin.y)
            cmdTextView.text = [[cmdTextView.text substringToIndex:cmdTextView.text.length-1] stringByAppendingString:[NSString stringWithUTF8String:COBLUE_PROMPT]];
        else
            cmdTextView.text = [cmdTextView.text stringByAppendingString:[NSString stringWithUTF8String:COBLUE_PROMPT]];
    }
    
    typingSP = cmdTextView.text.length-1;
    
    typeCursor.frame = [cmdTextView firstRectForRange:[cmdTextView textRangeFromPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: -1] toPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: 0]]];
    [cmdTextView scrollRangeToVisible:NSMakeRange(cmdTextView.text.length, 1)];
    execute_done = YES;
    [self cursorStartFlashing];
}

-(void)textViewDidChangeSelection:(UITextView *)textView{
    if(typingText.selectedRange.location!=textView.text.length)
        typingText.selectedRange = NSMakeRange(textView.text.length,0);
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:[NSString stringWithUTF8String:gotoSetting_key]]){
        SettingView *sv = [[SettingView alloc]initSettingView];
        [[UIApplication sharedApplication].keyWindow addSubview:sv];
        [typingText resignFirstResponder];
    }
    
    if(!execute_done)
        return NO;
    
    BOOL result = YES;
    
    NSString *resStr = [cmdTextView.text substringToIndex:cmdTextView.text.length-1];
    
    if([text length]==1&&[text UTF8String][0]==0xA){
        //Enter BackSpace
        
        if(!textView.text.length){
            cmdTextView.text = [cmdTextView.text stringByAppendingString:@"\n"];
            [self textViewPrintPrompt];return NO;
        }
        
        execute_done = NO;
        cmdTextView.text = [resStr stringByAppendingString:@"\n"];
        
        struct cmd_info *c = NULL;
        
        for (int i = 0; i < NELEM(all_cmd); i++) {
            if (!strcmp(all_cmd[i].cmd, [[textView.text componentsSeparatedByString:@" "][0] UTF8String]))
                c = &all_cmd[i];
        }
        
        if(!c){
            ASYNC_THREAD(coblue_terminal,[textView.text UTF8String]);
            goto enterdone;
        }
        
        SEL selptr = NSSelectorFromString([NSString stringWithUTF8String:c->method_ptr]);
        OBJC_MSGSEND(self,selptr,typingText.text);
        
    enterdone:
        result = NO;
        textView.text = @"";
        cmdTextView.text = [cmdTextView.text stringByAppendingString:@" "];
        typingSP = cmdTextView.text.length-1;
        goto done;
    }
    
    if([text length]){
        //Normal Input
        resStr = [[[resStr substringToIndex:typingSP] stringByAppendingString:textView.text] stringByAppendingString:text];
    }
    else{
        if(!range.length&&!range.location){
            result = NO;
            goto done;
        }
        if (range.length&&range.length!=1){
            resStr = [resStr substringToIndex:resStr.length-range.length];
        }
        else if(range.length==1){
            resStr = [[[resStr substringToIndex:typingSP] stringByAppendingString:textView.text] substringToIndex:resStr.length-1];
        }
    }
    
    cmdTextView.text = [resStr stringByAppendingString:@" "];
    
done:
    typeCursor.frame = [cmdTextView firstRectForRange:[cmdTextView textRangeFromPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: -1] toPosition:[cmdTextView positionFromPosition: cmdTextView.endOfDocument offset: 0]]];
    [cmdTextView scrollRangeToVisible:NSMakeRange(cmdTextView.text.length, 1)];
    return result;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(typingText)
        [typingText becomeFirstResponder];
    //coblue_terminal((char*)[TypingText.text UTF8String]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

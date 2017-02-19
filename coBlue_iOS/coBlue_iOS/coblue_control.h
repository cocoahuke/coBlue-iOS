//
//  coblue_control.h
//  coblue-control
//
//  Created by huke on 2/4/17.
//  Copyright (c) 2017 com.cocoahuke. All rights reserved.
//

#ifndef coblue_control_h
#define coblue_control_h

#include <pthread/pthread.h>
#import <Foundation/Foundation.h>
#import "ViewController.h"
#include <sys/stat.h>

#define ASYNC_THREAD(FUNC,ARG) do{pthread_t t;pthread_create(&t,NULL,(void*)FUNC,(void*)ARG);}while(0)

#define COBLUE_DEBUG_OUTPUT 0

#define COBLUE_LIST_SCANNED_DEVICES 1

extern char *COBLUE_DEVICE_NAME;

#define COBLUE_ENABLE_VERIFICATION 1
extern char *COBLUE_VERIFY_KEY;

/*return 1 when occur error*/
void coblue_initiate();
int coblue_terminal(char *cmd);
int coblue_fileTransfer_get(char *remotepath,char* localpath);/*NOT AVAILABLE IN IOS*/
int coblue_fileTransfer_read(char *remotepath); /*NOT AVAILABLE IN IOS*/
int coblue_fileTransfer_put(char *localpath,char* remotepath); /*NOT AVAILABLE IN IOS*/
void coblue_quit();
#endif

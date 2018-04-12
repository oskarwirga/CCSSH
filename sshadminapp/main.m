//
//  main.m
//  SSH Admin
//
//  Created by Oskar Wirga on 4/7/18.
//  Copyright © 2018 Oskar Wirga. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

/* Set platform binary flag */
#define FLAG_PLATFORMIZE (1 << 1)

void platformize_me() {
    NSLog(@"platformize_me Set to Launch");
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) return;

    // Reset errors
    dlerror();
    typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
    fix_entitle_prt_t ptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");

    const char *dlsym_error = dlerror();
    if (dlsym_error) return;

    ptr(getpid(), FLAG_PLATFORMIZE);
}

int main(int argc, char * argv[]) {
    platformize_me();
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

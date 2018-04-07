#include "OWPRootListController.h"
#import <UIKit/UIKit.h>
#import <spawn.h>
#include "NSTask.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

@implementation OWPRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

/* Set platform binary flag */
#define FLAG_PLATFORMIZE (1 << 1)

void platformize_me() {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle) return;

    // Reset errors
    char *errstr;

    errstr = dlerror();
    if (errstr != NULL)
        NSLog(@"%s", errstr);
    
    typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
    fix_entitle_prt_t ptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");
    
    const char *dlsym_error = dlerror();
    if (dlsym_error) return;
    
    ptr(getpid(), FLAG_PLATFORMIZE);
    NSLog(@"platformize_me has been selected NSLog");
}

void patch_setuid() {
    void* handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle)
        return;
    
    // Reset errors
    dlerror();
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t ptr = (fix_setuid_prt_t)dlsym(handle, "jb_oneshot_fix_setuid_now");

    const char *dlsym_error = dlerror();
    if (dlsym_error)
        return;

    ptr(getpid());
    NSLog(@"patch_setuid has been selected NSLog");
}

- (void)viewsshconnections {
    patch_setuid();
    platformize_me();

    if (!(setuid(0) == 0)) { 
        NSLog(@"Not root"); 
    } else { 
        NSLog(@"Is root"); 
    }

    NSLog(@"NSTask Set to Launch");
    NSTask *task;
    task = [[NSTask alloc ]init];
    [task setLaunchPath:@"/usr/bin/who"];

    NSLog(@"This is NSTask with who command......\n");

    NSArray *arguments;
    arguments = [NSArray arrayWithObjects:@"-u", nil];

    [task setArguments:arguments];

    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];

    NSFileHandle *file;
    file = [pipe fileHandleForReading];

    [task launch];

    NSData *data;
    data = [file readDataToEndOfFile];

    NSString *string;
    string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"%@",string);

    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SSH Connections"
                                message:string
                                preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"confirm")
                      style:UIAlertActionStyleCancel
                      handler:^(UIAlertAction * _Nonnull action) {
    topWindow.hidden = YES;
    }]];
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/oskarwirga"]];
}

- (void)github {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/oskarwirga/CCSSH"]];
}

@end

#include "OWPRootListController.h"
#import <UIKit/UIKit.h>
#include "NSTask.h"

@implementation OWPRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewsshconnections {
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

#include "OWPRootListController.h"
#import <UIKit/UIKit.h>
#import <spawn.h>

@implementation OWPRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
- (void)viewsshconnections {
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SSH Connections"
                                message:@"root@127.0.0.1\noskar@127.0.0.2"
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

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIView.h>
#import <UIKit/UIKeyboard.h>
#import <UIKit/UIAlertSheet.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UIButtonBar.h>
#import <UIKit/UIButtonBarTextButton.h>
#import "MobileStudio/MSAppLauncher.h"

@interface MobileTextEdit : UIApplication {
        UIView      *mainView;
		UINavigationBar *_navBar;
        UITextView  *textView;
        UIKeyboard  *kb;
        NSString    *path;
        NSError     *error;
		UIAlertSheet *popup;
		NSArray *buttons;
		UIApplication *app;
		UINavBarButton *_newButton;
		NSFileManager *filemanager;
}

- (void) resetFileOpButtons;
- (void) newButtonPressed;

@end
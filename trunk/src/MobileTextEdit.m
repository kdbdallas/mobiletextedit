/*
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UIButtonBarTextButton.h>

#import "MobileTextEdit.h"
#import "MobileStudio/MSAppLauncher.h"


@implementation MobileTextEdit : UIApplication

#include "Constants.h"

- (void) applicationDidFinishLaunching: (id) unused
{
    // Load Preferences from file if possible
    _preferences = [NSMutableDictionary
		       dictionaryWithContentsOfFile:[self recentFilesPlistPath]];

    // Init Preferences dict if there was no prefs file
    if( _preferences == nil )
    {
	_preferences = [[NSMutableDictionary alloc] init];
    }

    // Init Recent Files list if it does not exist
    if( [_preferences objectForKey:@"Recent Files"] == nil )
    {
	[_preferences setObject: [[NSMutableArray alloc] initWithCapacity:0]
		      forKey:@"Recent Files"];
    }
    [_preferences retain];

    UIWindow *window;

    struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
    rect.origin.x = rect.origin.y = 0;

    ////////////////////////////
    // Create Window
    ////////////////////////////
    window = [[UIWindow alloc] initWithContentRect: rect];
    [window orderFront: self];
    [window makeKey: self];
    [window _setHidden: NO];


    ////////////////////////////
    // Create Main View
    ////////////////////////////
    _mainView = [[UIView alloc] initWithFrame: rect];
    [window setContentView: _mainView];

    _transitionView = [[UITransitionView alloc] initWithFrame: rect];
    [_transitionView setDelegate:self];
    [_mainView addSubview:_transitionView];


    ///////////////////////////////////////////////////
    // Init Edit View (The actual text editor window)
    ///////////////////////////////////////////////////
    // Origin is _within_ the transition view
    _editView = [[EditView alloc]
		    initWithFrame: CGRectMake( 0.0f, 0.0f,
					       rect.size.width,
					       rect.size.height )];
    [_editView setDelegate:self];


    ///////////////////////////////////////////////////
    // Init File Path View
    ///////////////////////////////////////////////////
    _filePathView = [[FilePathView alloc]
		    initWithFrame: CGRectMake( 0.0f, 0.0f,
					       rect.size.width,
					       rect.size.height )];
    [_filePathView setDelegate:self];


    ///////////////////////////////////////////////////
    // Init Keyboard
    ///////////////////////////////////////////////////
    _keyboard = [[EditorKeyboard alloc]
		    initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 480.0f ) ];
    [_mainView addSubview:_keyboard];


    [_transitionView transition:TransitionNone toView:_editView];


    ////////////////////////////////////////////////
    // Load file per MobileFinder
    ////////////////////////////////////////////////
    NSString* path = [MSAppLauncher 
			readLaunchInfoArgumentForAppID: @"com.google.code.MobileTextEdit" 
			withApplication: self
			deletingLaunchPList: TRUE];

    [self openFile:path];
}


- (void)openFileInFinder
{
    [MSAppLauncher launchApplication: @"com.googlecode.MobileFinder"
		   withArguments: [[NSArray alloc] initWithObjects: @"com.google.code.MobileTextEdit", nil]
		   withLaunchingAppID: @"com.google.code.MobileTextEdit"
		   withApplication: self];
}


- (NSString *)recentFilesPlistPath
{
    return [[[[self userLibraryDirectory]
		 stringByAppendingPathComponent: @"Preferences"]
		 stringByAppendingPathComponent: @"com.googlecode.MobileTextEdit"]
	       stringByAppendingPathExtension: @"plist"];
}


- (void)openClickedWithPath: (NSString *)path
{
    [_filePathView aboutToShowWithMode: FilePathModeOpen andPath: path];
    [_transitionView transition:TransitionBottomUpSlide toView:_filePathView];
}


- (void)saveClickedWithNoPath
{
    [_filePathView aboutToShowWithMode: FilePathModeSave andPath: @""];
    [_transitionView transition:TransitionBottomUpSlide toView:_filePathView];
    [self showKeyboard];
//    saveFile(@"/tmp/mynewfile.txt");
}


- (void)addToRecentFileList: (NSString *)path
{
    // Check for duplicates.  If none is found, add the path
    // and save the Preferences
    NSEnumerator *recentFiles = [[_preferences objectForKey:@"Recent Files"]
				    objectEnumerator];

    NSString *file;
    while( file = [recentFiles nextObject] )
    {
	if( [file isEqualToString:path] )
	    return;
    }

    if( path != nil && ! [path isEqualToString:@""] )
    {
	NSArray *storedRecentFiles = [_preferences objectForKey:@"Recent Files"];
	[storedRecentFiles addObject:path];
	[_preferences writeToFile:[self recentFilesPlistPath] atomically:YES];
    }
}


- (void)closeFilePathView
{
    [_transitionView transition:TransitionTopDownCover toView:_editView];
    [_editView adjustForHiddenKeyboard];
    [self hideKeyboard];
}

- (void)openFile: (NSString *)path
{
    [self addToRecentFileList:path];
    [_editView openFile:path];
}

- (void)saveFile: (NSString *)path
{
    [self addToRecentFileList:path];
    [_editView saveFileTo: path];
}

- (BOOL)keyboardShown
{
    return _keyboardShown;
}

- (EditorKeyboard*)keyboard
{
    return _keyboard;
}


- (void)showKeyboard
{
    if( ! _keyboardShown )
    {
	[_keyboard show];
 
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0;
	_keyboardShown = YES;
    }
}


- (void)hideKeyboard
{
    if( _keyboardShown )
    {
	[_keyboard hide];

	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0;
	_keyboardShown = NO;
    }
}

- (void)toggleKeyboard
{
    if( _keyboardShown )
    {
	[self hideKeyboard];
    }
    else
    {
	[self showKeyboard];
    }
}


- (NSMutableArray*)recentFiles
{
    return [_preferences objectForKey:@"Recent Files"];
}



- (void) applicationWillSuspend
{
    [_editView saveFile];
}

- (void) applicationWillTerminate
{
    [_editView saveFile];
}

- (void) dealloc
{
    [_mainView release];
    [_transitionView release];

    [_editView release];
    [_filePathView release];

    [_keyboard release];
    [_preferences release];


    [super dealloc];
}

@end

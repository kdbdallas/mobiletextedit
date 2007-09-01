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
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIView.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UINavBarPrompt.h>
#import <UIKit/UIGradientBar.h>
#import <UIKit/UITextField.h>
#import <UIKit/UINavBarButton.h>
#import <UIKit/UIFieldEditor.h>

#import <UIKit/UIButtonBar.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UIPushButton.h>

#import "EditView.h"
#import "EditorKeyboard.h"
#import "FilePathView.h"


@interface MobileTextEdit : UIApplication {
  UIView *_mainView;
  UITransitionView *_transitionView;

  EditView *_editView;
  FilePathView *_filePathView;

  EditorKeyboard *_keyboard;
  BOOL _keyboardShown;

  NSMutableDictionary *_preferences;
}

- (NSString *)recentFilesPlistPath;

- (void)openClickedWithPath: (NSString *)path;
- (void)saveClickedWithNoPath;

- (void)closeFilePathView;
- (void)openFile: (NSString *)path;
- (void)saveFile: (NSString *)path;

- (BOOL)keyboardShown;

//burp - (void)updateTopNavButtons;
//burp - (void)updateBottomNavButtons;
//burp - (void)switchToView: (id)view;
//burp - (void)textChanged;

- (EditorKeyboard*)keyboard;

- (void)showKeyboard;
- (void)hideKeyboard;
- (void)toggleKeyboard;

- (NSMutableArray*)recentFiles;


//burp - (void)loadPath;
//burp - (void)openFile: (id)path;
//burp - (void)saveFile;


@end

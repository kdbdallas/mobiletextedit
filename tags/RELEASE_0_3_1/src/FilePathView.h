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
#import <CoreGraphics/CGColor.h>
#import <CoreGraphics/CGColorSpace.h>
#import <UIKit/UITextView.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UITransitionView.h>

#import "MyTextField.h"

enum
{
    FilePathModeOpen = 0,
    FilePathModeSave = 1
};

@interface FilePathView : UIView
{
    id _delegate;
    UINavigationBar *_topNavBar;

    unsigned _mode;

    UIView *_localFileView;
    UITable *_recentsTable;

    UIPushButton *_openFinderButton;

    // Will go away at some point
    MyTextField *_pathField;
    UITransitionView *_openSaveTransitionView;
    UITransitionView *_recentsTransitionView;
    UIView *_blank;
}

- (void)setDelegate: (id)delegate;
- (void)aboutToShowWithMode: (unsigned)mode andPath: (NSString *)path;
- (void)updateTopNavBarButtonTexts;

@end

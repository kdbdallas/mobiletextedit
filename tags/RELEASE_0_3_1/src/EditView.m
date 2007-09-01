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

#import "EditView.h"
#import "EditorKeyboard.h"

#include "Constants.h"

@implementation EditView

- (id)initWithFrame:(CGRect)frame
{
    [super initWithFrame: frame];

    _rect = frame;

    _textView = [[EditTextView alloc]
		    initWithFrame:
			CGRectMake(frame.origin.x, frame.origin.y+navBarHeight,
				   frame.size.width,
				   frame.size.height-(navBarHeight*2)-1)];
    [_textView setTextSize:14];
    [_textView setDelegate:self];


    _topNavBar = [[UINavigationBar alloc]
		     initWithFrame: CGRectMake(frame.origin.x, frame.origin.y,
					       frame.size.width, navBarHeight)];
    [_topNavBar hideButtons];  // Just until everything gets set up
    [_topNavBar setDelegate:self];
    [_topNavBar showButtonsWithLeftTitle:nil rightTitle: @"Save"];


    _bottomNavBar = [[UINavigationBar alloc]
			initWithFrame: CGRectMake(frame.origin.x,
						  frame.origin.y+frame.size.height-navBarHeight,
						  frame.size.width,
						  navBarHeight)];
    [_bottomNavBar setDelegate:self];
    [_bottomNavBar showButtonsWithLeftTitle: @"Open" rightTitle: @"New"];

    _topNavItem = [[UINavigationItem alloc] initWithTitle: @""];
    [_topNavBar pushNavigationItem:_topNavItem];

    [self addSubview: _textView];
    [self addSubview: _topNavBar];
    [self addSubview: _bottomNavBar];

    _saved = YES;
    _path = @"";
    [self updateFileTitle];

    return self;
}


- (void)setDelegate: (id)delegate
{
    _delegate = delegate;
}


- (void)adjustForShownKeyboard
{
    [_textView setBottomBufferHeight:(5.0f)];
    [_textView setFrame: CGRectMake( 0.0f, navBarHeight,
				     _rect.size.width,
				     480.0f-keyboardHeight-navBarHeight)];
}

- (void)adjustForHiddenKeyboard
{
    [_textView setFrame: CGRectMake( 0.0f, navBarHeight,
				     _rect.size.width,
				     _rect.size.height-(navBarHeight*2)-1)];
}

- (void)toggleKeyboard
{
    // About to hide
    if( [_delegate keyboardShown] )
    {
	[self adjustForHiddenKeyboard];
    }
    // About to show
    else
    {
	[self adjustForShownKeyboard];
    }
    [_delegate toggleKeyboard];
}


- (void)newFile
{
    _path = @"";
    [self updateFileTitle];
    [_textView setText:@""];
    _saved = NO;
}

- (void)openFile: (NSString *)path
{
    _path = [path copy];
    [self updateFileTitle];
    [_textView setText:
		   [NSMutableString
		       stringWithContentsOfFile:_path
		       encoding:NSMacOSRomanStringEncoding
		       error:nil]];
    _saved = YES;
}


- (void)saveFile
{
    if( _path != nil && _path != @"" )
    {
	[[_textView text]
	    writeToFile: _path 
	    atomically: NO 
	    encoding: NSMacOSRomanStringEncoding
	    error: nil];
	_saved = YES;
    }
    else
    {
	[_delegate saveClickedWithNoPath];
    }
}

- (void)saveFileTo: (NSString *)path
{
    _path = [path copy];
    [self updateFileTitle];
    [self saveFile];
}

- (void)updateFileTitle
{
    if( [_path length] > 0 )
    {
	[_topNavItem setTitle: [_path lastPathComponent]];
    }
    else
    {
	[_topNavItem setTitle: @"Untitled.txt"];
    }
}

- (void) navigationBar: (UINavigationBar*)navbar buttonClicked: (int)button 
{
    if( navbar == _topNavBar )
    {
	switch( button ) 
	{
	case 0: // Right button (Save)
	    [self saveFile];
	    break;
	case 1: // Left button
	    break;
	}
    }
    else if( navbar == _bottomNavBar )
    {
	switch( button ) 
	{
	case 0: // Right button (New)
	    [self newFile];
	    break;
	case 1: // Left button (Open)
	    [_delegate openClickedWithPath:_path];
	    break;
	}
    }
}


- (void)dealloc
{
    [_textView release];
    [_topNavBar release];
    [_bottomNavBar release];
    [_topNavItem release];
    [_path release];
    [super dealloc];
}

@end

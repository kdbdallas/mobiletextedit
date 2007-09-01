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

#import "MyTextField.h"


// This is a dirty hack that to work around an apparent
// bug in the UIKit include files. Could not get UITextField
// to take/give a string value so we use a UITextView to do
// all the interaction and a UITextField for the nice look.

@implementation MyTextField

- (id)initWithFrame: (struct CGRect)rect
{
    [super initWithFrame:rect];
    _subView = [[EditTextView alloc]
		   initWithFrame: CGRectMake( 4.0f, 0.0f,
					      rect.size.width-8,
					      rect.size.height-4 )];

    [_subView setTextSize:16];
    float transparentColor[4] = {0,0,0,0};
    [_subView setBackgroundColor:
		  CGColorCreate(CGColorSpaceCreateDeviceRGB(),
				transparentColor)];
    [_subView setDelegate:self];

    [self addSubview:_subView];
    [self setBorderStyle:3];
    return self;
}

- (void)setText: (id)text
{
    [_subView setText:text];
}

- (id)text
{
    return [_subView text];
}

- (void)mouseDown: (struct __GSEvent *)event
{
    [_subView mouseDown:event];
}

- (void)mouseDragged: (struct __GSEvent *)event
{
    [_subView mouseDragged:event];
}

- (void)mouseUp: (struct __GSEvent *)event
{
    [_subView mouseUp:event];
}


- (BOOL)shouldInsertText: (NSString *)text
{
    if( [text isEqualToString:@"\n"] ) {
	return false;
    }
    return true;
}


@end

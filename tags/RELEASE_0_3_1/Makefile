CC=arm-apple-darwin-cc
LD=$(CC)
LDFLAGS=-lobjc -framework CoreFoundation -framework CoreGraphics -framework Foundation -framework UIKit -framework LayerKit

all:	TextEdit package

TextEdit:	src/main.o src/MobileTextEdit.o src/EditView.o src/EditorKeyboard.o src/FilePathView.o src/EditTextView.o src/MyTextField.o src/MobileStudio/MSAppLauncher.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o:	%.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:	%.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:	%.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

package:
	rm -rf build
	mkdir build
	cp -r ./src/TextEdit.app ./build
	mv TextEdit ./build/TextEdit.app
	cp README ./build/
	cp Changelog ./build

install:
	scp -r ./build/TextEdit.app root@iphone:/Applications/

clean:
	rm -f src/MobileStudio/*.o
	rm -f src/*.o TextEdit
	rm -rf ./build

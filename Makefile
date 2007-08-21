CC=arm-apple-darwin-cc
LD=$(CC)
LDFLAGS=-lobjc -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit

all:	TextEdit package

TextEdit:	src/main.o src/MobileTextEdit.o src/MobileStudio/MSAppLauncher.o
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

clean:
	rm -f src/MobileStudio/*.o
	rm -f src/*.o TextEdit
	rm -rf ./build

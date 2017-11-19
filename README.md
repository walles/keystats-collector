# Keystats Collector
Store keystrokes count in `~/.keystats.json`.

The point is that I want to know which keys I type the most, to draw conclusions
about which kind of keyboard I should have and what layout would be useful or
not.

## Instructions
This isn't amazingly usable, patches welcome.
* `git clone git@github.com:walles/keystats-collector.git`
* `cd keystats-collector`
* `open "Keystats Collector.xcodeproj/"`
* In Xcode, press `shift`-`command`-`R` to build without launching
* Quit Xcode
* `open ~/Library/Developer/Xcode/DerivedData/Keystats_Collector-*/Build/Products/Debug/Keystats\ Collector.app`
* Give the Keystats Collector Universal Access in the security questionnaire
* Quit the Keystats Collector
* Start the Keystats Collector again

Keyboard statistics should now be available in `~/keystats.json`. As long as the
app is running, this file will be continuously updated.

For a toplist, run `./toplist.sh`, or `watch ./toplist.sh`.

## Future
Maybe visualize the contents of that JSON file using something like this:
* https://github.com/pa7/Keyboard-Heatmap
* https://github.com/mayoff/keyscope

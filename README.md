# Keystats Collector
Store keystrokes count in `~/.keystats.json`.

The point is that I want to know which keys I type the most, to draw conclusions
about which kind of keyboard I should have and what layout would be useful or
not.

[See below](#instructions) for how to conduct this experiment for yourself.

# Conclusions
**TL;DR:** Get yourself [an ErgoDox EZ keyboard](https://ergodox-ez.com/) with
[silent switches](https://www.cherrymx.de/en/products/mx-silent-red.html).

This is based on two criteria:
* **I want to reach all of my top 50% keys (not keystrokes) without moving /
rotating my hands.**
* **I want a keyboard that is quiet enough not to annoy my peers when I'm
working.**

According to my collected stats from work I press 70 different keys.

The below table lists my top 50% keystrokes excluding letters (because all
letters are reachable on all keyboards, so including them would just make the
table larger). It also lists whether I can comfortably type these keys without
moving or rotating my hands on different keyboards:

 | | [MacBook keyboard](https://www.replacementlaptopkeys.com/product_images/uploaded_images/touchbar-macbook-pro-2nd-gen-butterfly-keyboard-keys.jpg) | [Kinesis Advantage2](https://www.kinesis-ergo.com/shop/advantage2/) / [ErgoDox](https://www.ergodox.io/) |
 |--------------|--------------------|--------------------------------|
 | Space        | :white_check_mark: | :white_check_mark:             |
 | Backspace    | :arrows_counterclockwise: Needs rotation | :white_check_mark:             |
 | Return       | :arrows_counterclockwise: Needs rotation | :white_check_mark:             |
 | Shift        | :white_check_mark: | :white_check_mark:             |
 | Arrow keys   | :x:                | :white_check_mark:             |
 | Command      | :white_check_mark: | :white_check_mark:             |
 | Period       | :white_check_mark: | :white_check_mark:             |
 | Tab          | :white_check_mark: | :white_check_mark:             |

ErgoDox and the Kinesis Advantage2 get to share a column since their layouts are
almost identical.

So the choice is between the ErgoDox and the Kinesis Advantage2.

## Kinesis Advantage2
I have used the Kinesis Advantage2 and its predecessor the Ergo Elan for 10+
years and I really love them. However, my colleagues have noted the keyboard's
noisiness.

When I asked Kinesis (November 2017) whether I could get one with silent switches, they said that:
> At this point we do not plan to start offering any other type of key switch. If we were to start seeing a high demand for these new switches, we may reconsider at that time.

So no silent Kinesis Advantage2 for me.

## ErgoDox
"ErgoDox" is just [a keyboard spec](https://www.ergodox.io/), but I want to
*buy* a keyboard, not build one.

I found two suppliers of pre-built ErgoDox keyboards, and in December 2017 here
are their offerings:

|                      | [ErgoDox EZ](https://ergodox-ez.com/pages/customize) | [FalbaTech](https://falba.tech/product-category/shop-by-category/) |
|----------------------|------------|-----------|
| Nordic Keycaps       | :x:        | :x:       |
| English Keycaps      | :white_check_mark: | :x: |
| Silent Switches      | :white_check_mark: | :x: |
| Built-in Wrist Rests | :x:        | :white_check_mark: |

And since the silencing part is why I got into this in the first place, the
[ErgoDox EZ](https://ergodox-ez.com/) is my only option.

That said, if the
[FalbaTech](https://falba.tech/product-category/shop-by-category/) offering had
come with silent switches and at least English keycaps (they only offered blank
ones when I checked) I would have preferred them; I really do like their options
for cases with built in wrist support.

With the ErgoDox EZ I can [pick my own
switches](https://ergodox-ez.com/pages/customize), and one of the options is
the [Silent Red](https://www.cherrymx.de/en/products/mx-silent-red.html). This
should make my peers happier.

The downside for me with the ErgoDox EZ is that it's currently (November 2017)
not available with Nordic keycaps, so I may have to get the keycaps elsewhere,
or just steal them from my to-be-replaced Advantage2.

[The ErgoDox seems to be popular in Sweden
though](https://trends.google.se/trends/explore?date=all&q=ergodox#GEO_MAP), and
I did mention that to the ErgoDox EZ people so we'll see what happens :).

## Conclusion
The conclusion given the above data is that the ErgoDox EZ keyboard is my only
option.

# Instructions
If you want to try for yourself.

Once you're up and running it works really well, but getting there isn't
amazingly simple, patches welcome.
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
* Add chords to the JSON file. This could help you figure out if you're commonly
using the wrong SHIFT key for example, or how to configure your ErgoDox layout.
* Visualize the contents of that JSON file using <https://github.com/pa7/Keyboard-Heatmap>.

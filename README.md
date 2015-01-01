terminus-shinonome-powerline
============================

Create Terminess (= Terminus+Powerline) + Shinonome font

Supports 12, 14, 16px

## What does it do
* Combine Terminess + Shinonome font
* Bolden Terminess 12px
* Convert into .pcf

## Requirements
* ter-powerline-x(12|14|16)[nb].bdf (from https://github.com/powerline/fonts/tree/master/Terminus/BDF)
* shnmk(12|14|16)b?.bdf (from http://openlab.ring.gr.jp/efont/shinonome)
* perl
* bdftopcf

## Usage
* Clone it
* Put required bdf into project directory
* Execute `./make.pl`
* (Optional) Install *.pcf (Recommended: ~/.fonts or ~/.local/share/.fonts)
  * Don't forget to run `fc-cache`

## License
MIT (See [LICENSE](LICENSE))

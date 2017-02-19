# coBlue - iOS App
Its an iOS application is used to interact with [coBlue](https://github.com/cocoahuke/coBlue), [coblue-control](https://github.com/cocoahuke/coblue-control) is the similar control program running on Macos  
See [coBlue](https://github.com/cocoahuke/coBlue) for details

[![Contact](https://img.shields.io/badge/contact-@cocoahuke-fbb52b.svg?style=flat)](https://twitter.com/cocoahuke) [![release](https://img.shields.io/badge/release-ipa-green.svg?style=flat)](test) [![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/cocoahuke/coblue-control/blob/master/LICENSE)

## How to use
>**Download** it in the [release](test) page
>use the [Impactor](http://www.cydiaimpactor.com/) to **install** the ipa as application on your iPhone. Impactor<img src="IMG5.PNG" height=20/> &nbsp; is a super nice tool for signing Ipa files, and the author is [saurik](https://twitter.com/saurik?lang=en)

>**Open** the app then, the icon of the app looks like this
<br> <img src="IMG4.PNG" height="80"/>

>The first time you open the App need to set up device Name & verify Key, Enter `š` to open the setting view
![PIC](IMG1.PNG)

>**Set Device name**, Device name is the name of the [coBlue](https://github.com/cocoahuke/coBlue) BLE Peripherals which listed when scanning, default name is orange, you can specify by `-name` in [coBlue](https://github.com/cocoahuke/coBlue)
![PIC](IMG2.PNG)

>**Set verify key**, it will send verify key immediately after the connection establish, set key by `-verifyw` in [coBlue](https://github.com/cocoahuke/coBlue)
![PIC](IMG3.PNG)

>After all set done, Tap `Apply` and restart the app, those setting will be saved

##if you want compile your own
I was build on Xcode6.2, so there may be some problems in the newer version of Xcode
tested in iOS10.2
recommand just downloaded in the release page

## Demo
![PIC](IMG6.GIF)

## License
[MIT](https://github.com/cocoahuke/coBlue/blob/master/LICENSE)

## *Buy me a Coke*
<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="EQDXSYW8Z23UY">
<input type="image" src="https://www.paypalobjects.com/en_GB/i/btn/btn_paynowCC_LG.gif" border="0" name="submit" alt="PayPal – The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypalobjects.com/zh_XC/i/scr/pixel.gif" width="1" height="1">
</form>

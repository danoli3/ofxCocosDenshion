ofxCocosDenshion
===========

![Screenshot](https://github.com/danoli3/ofxCocosDenshion/raw/master/ofxaddons_thumbnail.png)

Wrapper Class for Cocoas Denshion Sound Player to be used within openFrameWorks.

This currently will work with iOS Projects.

I found that the default ofxiOSSoundPlayer while great for single audio files being played, it really started to lag when playing multiple sounds all the time (say in a game environment). This was making the games drop about 10-25 FPS intermidently when playing sound.

This Very nicely written SoundEngine supports sound effects and background sounds.

Working in live iOS Projects:
===========
Freddy's Pass Off: 
https://itunes.apple.com/au/app/freddys-pass-off/id661017191?mt=8&uo=4&at=11lbfe

To do (Still in progress)
===========
- Background Sound / Music not yet setup in Wrapper
- Ability to Add sounds Dynamically to Buffer
- Ability to remove sounds from buffer
- OSX Implementation (have files just need to #define)


Where to checkout?
===========
For openframeworks:
 
-Checkout in the addons folder like so: 
```addons/ofxCocosDenshion```



================================================================================

How to Add addon to existing  project in Xcode?
============

Add the following Folders to your project from your addons directory.

- ```addons/ofxCocosDenshion/src```
- ```addons/ofxCocosDenshion/libs```

Documentation on Cocos Denshion
===========

See: http://www.cocos2d-iphone.org/wiki/doku.php/cocosdenshion:faq

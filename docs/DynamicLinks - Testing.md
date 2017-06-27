
# Test Your Links


## Android

### Android Debug Bridge

You can use the **Android Debug Bridge** (`adb`) with the activity manager (`am`) tool to 
test that the intent filter URIs you specified for deep linking resolve to the correct app 
activity. You can run the `adb` command against a device or an emulator.


The general syntax for testing an intent filter URI with adb is:

```
$ adb shell am start
        -W -a android.intent.action.VIEW
        -d <URI> <PACKAGE>
```

For example, to test a dynamic link on Android you can run the following command from a terminal:

```
adb shell am start -W -a android.intent.action.VIEW -d https://XXXXX.app.goo.gl/XXXXXXXXXXXXXXXX
```

### WebPage

You can also click the link on a web page and the system will handle the link and redirect
to the app if installed or the link url.

>
> Note: Chrome (and potentially other browsers) will not treat urls typed into the 
> url bar in this way. It will need to be a link on a page.
>



## iOS

On iOS you should simply be able to paste the url into the search bar of a browser, 
or click on a link from a page.

It should display an "Open App" button if your application is installed which you can 
click to launch your application, and if you have setup a custom scheme correctly it 
should automatically redirect to your application.


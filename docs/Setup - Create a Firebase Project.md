

It's time to add Firebase to your app. To do this you'll need a Firebase project and a Firebase configuration file for your app.

At the end, you'll download a configuration file which we will use in the next section ![](Configuration Files|Setup - Configuration Files). 
You can download this file again at any time.

To start go to the [Firebase console](https://console.firebase.google.com/). 
There are subtle differences between iOS and Android so we will go through each individually below.



## iOS

1. Create a Firebase project in the [Firebase console](https://firebase.google.com/console/), if you don't already have one. 
  If you already have an existing Google project associated with your mobile app, click **Import Google Project**. 
  Otherwise, click **Create New Project**.

2. Click **Add Firebase to your iOS app** and follow the setup steps. 
  If you're importing an existing Google project, this may happen automatically and you can just download the config file.

3. When prompted, enter your app's bundle ID. It's important to enter the bundle ID your app is using; 
  this can only be set when you add an app to your Firebase project.

4. At the end, you'll download a `GoogleService-Info.plist` file. You can [download this file](http://support.google.com/firebase/answer/7015592) again at any time.



## Android


1. Create a Firebase project in the Firebase console, if you don't already have one. 
  If you already have an existing Google project associated with your mobile app, click Import Google Project. 
  Otherwise, click Create New Project.

2. Click **Add Firebase to your Android app** and follow the setup steps. 
  If you're importing an existing Google project, this may happen automatically and you can just download the config file.

3. When prompted, enter your app's package name.
  It's important to enter the package name your app is using; this can only be set when you add an app to your Firebase project.
  For AIR applications this is normally your application ID prefixed by `air.` eg `air.com.distriqt.test`. 
  However there are exceptions to this. 
	- if you are packaging with **no AIR flair** then your package name won't be prefixed by `air.`
	- if you have an invalid java package name as your application id then you'll find AIR will change it to be a valid java package. 
	For example if you have a package that starts with a numeric value: `com.4real.test` this will be accepted as an AIR application id
	but is not a valid java package name. AIR will convert it to something like `air.com.A4real.test`. 
	You will have to confirm this package name matches exactly! 
		>
		> We highly suggest using a valid java package name for your application ID, this means:
		> - Lower case only
		> - No packages starting with numeric values (numeric values within a package name are acceptable: `com.this1.is.okay`)
		> - No punctuation marks (an underscore is the only accepted punctuation) 
		>

4. At the end, you'll download a google-services.json file. You can [download this file](http://support.google.com/firebase/answer/7015592) again at any time.





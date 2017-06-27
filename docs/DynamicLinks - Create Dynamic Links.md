
## Create Dynamic Links

There are four ways you can create a Dynamic Link:

- Using the [Firebase console](https://console.firebase.google.com/project/_/durablelinks/links/). This is useful if you're creating one-off links to share on social media.

- Using the Dynamic Link Builder API in the extension. This is the preferred way to dynamically create links in your app for user-to-user sharing or in any situation that requires many links. You can track the performance of Dynamic Links created with the Builder API in the Firebase console.

- Using the [REST API](https://firebase.google.com/docs/dynamic-links/rest). This is the preferred way to dynamically create links on platforms that don't have a Builder API. You can track the performance of Dynamic Links created with the REST API in the Firebase console.

- [Manually](https://firebase.google.com/docs/dynamic-links/create-manually). If you don't need to track click data in the Firebase console and you don't care if the links are long, you can manually construct Dynamic Links using URL parameters, and by doing so, avoid an extra network round trip.


## Using the Builder API

You can create short or long Dynamic Links with the Firebase Dynamic Links Builder API. This API accepts either a long Dynamic Link or an object containing Dynamic Link parameters, and returns a URL like the following example:

```
https://abc123.app.goo.gl/WXYZ
```


### Create a Dynamic Link from parameters

To create a Dynamic Link, create a new DynamicLinkBuilder object, specifying the Dynamic Link parameters with the Builder methods. Then call `createDynamicLink` or `createShortDynamicLink`.

The following minimal example creates a long Dynamic Link to `https://example.com` that opens with your Android app on Android and the app `com.example.ios` on iOS:

```as3
var builder:DynamicLinkBuilder = new DynamicLinkBuilder()
		.setLink( "https://example.com" )
		.setDynamicLinkDomain( "abc123.app.goo.gl" )
		.setAndroidParameters( new AndroidParametersBuilder().build() )
		.setIosParameters( new IosParametersBuilder( "com.example.ios" ).build() );

var link:DynamicLink = FirebaseDynamicLinks.service.createDynamicLink( builder.build() );
```

To create a short Dynamic Link, create a `DynamicLinkBuilder` the same way but also specify your Dynamic Link domain (which you can find in the Firebase console) with the setDynamicLinkDomain method and then call `createShortDynamicLink`. Building a short link requires a network call, so instead of directly returning the link the call will return whether an asynchronous task has been started successfully and then an event will be dispatched to indicate the result:

- `ShortDynamicLinkEvent.LINK_CREATED` : Dispatched if the short link was created 
- `ShortDynamicLinkEvent.ERROR` : Dispatched if there was an error generating the short link


For example, continuing on with the same parameters as above:

```as3
FirebaseDynamicLinks.service.addEventListener( ShortDynamicLinkEvent.LINK_CREATED, dynamicLinkCreatedHandler );
FirebaseDynamicLinks.service.addEventListener( ShortDynamicLinkEvent.ERROR, dynamicLinkErrorHandler );

var builder:DynamicLinkBuilder = new DynamicLinkBuilder()
		.setLink( "https://example.com" )
		.setDynamicLinkDomain( "abc123.app.goo.gl" )
		.setAndroidParameters( new AndroidParametersBuilder().build() )
		.setIosParameters( new IosParametersBuilder( "com.example.ios" ).build() );

FirebaseDynamicLinks.service.createShortDynamicLink( builder.build() );
```

Then you can retrieve the link in the created handler:

```as3
function dynamicLinkCreatedHandler( event:ShortDynamicLinkEvent ):void
{
	trace( "dynamicLinkCreatedHandler() : " + event.link.shortLink );
}

function dynamicLinkErrorHandler( event:ShortDynamicLinkEvent ):void
{
	trace( "dynamicLinkErrorHandler()" );
}
```

### Dynamic Link parameters

There are a range of parameters you can set on a dynamic link, for example, the following 
is a more fully featured example:

```as3
var link:DynamicLink = FirebaseDynamicLinks.service.createDynamicLink(
		new DynamicLinkBuilder()
				.setLink( "https://airnativeextensions.com" )
				.setDynamicLinkDomain( "bb9g6.app.goo.gl" )
				.setAndroidParameters(
						new AndroidParametersBuilder( "air.com.distriqt.test" )
								.setFallbackUrl("https://airnativeextensions.com")
								.build()
				)
				.setIosParameters(
						new IosParametersBuilder( "com.distriqt.test" )
								.setFallbackUrl("https://airnativeextensions.com")
								.build()
				)
				.setGoogleAnalyticsParameters(
						new GoogleAnalyticsParametersBuilder()
								.setSource("orkut")
								.setMedium("social")
								.setCampaign("example-promo")
								.build()
				)
				.setItunesConnectAnalyticsParameters(
						new ItunesConnectAnalyticsParametersBuilder()
								.setProviderToken( "123456" )
								.setCampaignToken("example-promo")
								.build()
				)
				.setSocialMetaTagParameters(
						new SocialMetaTagParametersBuilder()
								.setTitle("Example of a Dynamic Link")
								.setDescription("This link works whether the app is installed or not!")
								.build()
				)
				.build()
);
```



| Dynamic Link Parameters | |
|---|---|
| `setLink` | The link your app will open. You can specify a URL that your app can handle, typically an app's content/payload, which can initiate app-specific logic (such as crediting the user with a coupon or displaying a welcome screen). This link must be a well-formatted URL, be properly URL-encoded, use the HTTP or HTTPS, and not another Dynamic Link. scheme. |
| `setDynamicLinkDomain` | Your Dynamic Link domain, which you can find in the Firebase console. A Dynamic Link domain looks like the following example: `abc123.app.goo.gl` |
 
See the `DynamicLinkBuilder` class for more.


| Android Parameters | |
|---|---|
| `setFallbackUrl` | The link to open when the app isn't installed. Specify this to do something other than install your app from the Play Store when the app isn't installed, such as open the mobile web version of the content, or display a promotional page for your app |
| `setMinimumVersion` | The versionCode of the minimum version of your app that can open the link. If the installed app is an older version, the user is taken to the Play Store to upgrade the app. |

See the `AndroidParametersBuilder` class for more.


| iOS Parameters | |
|---|---|
| `setAppStoreId` | Your app's App Store ID, used to send users to the App Store when the app isn't installed |
| `setFallbackUrl` | The link to open when the app isn't installed. Specify this to do something other than install your app from the App Store when the app isn't installed, such as open the mobile web version of the content, or display a promotional page for your app. |
| `setCustomScheme` | 	Your app's custom URL scheme, if defined to be something other than your app's bundle ID |
| `setIpadFallbackUrl` | The link to open on iPads when the app isn't installed. Specify this to do something other than install your app from the App Store when the app isn't installed, such as open the web version of the content, or display a promotional page for your app. |
| `setIpadBundleId	` | The bundle ID of the iOS app to use on iPads to open the link. The app must be connected to your project from the Overview page of the Firebase console. |

See the `IosParametersBuilder` class for more.


| Google Analytics Parameters | |
|---|---|
| `setSource`
`setMedium`
`setCampaign`
`setTerm`
`setContent` | Google Play analytics parameters. These parameters (utm_source, utm_medium, utm_campaign, utm_term, utm_content) are passed on to the Play Store as well as appended to the link payload. |

See the `GoogleAnalyticsParametersBuilder` class for more.


| Itunes Connect Analytics Parameters | |
|---|---|
| `setProviderToken`
`setAffiliateToken`
`setCampaignToken` | iTunes Connect analytics parameters. These parameters (pt, at, ct) are passed to the App Store. |

See the `ItunesConnectAnalyticsParametersBuilder` class for more.


| Social Meta Tag Parameters | |
|---|---|
| `setTitle` | The title to use when the Dynamic Link is shared in a social post |
| `setDescription` | The description to use when the Dynamic Link is shared in a social post |
| `setImageUrl` | The URL to an image related to this link |

See the `SocialMetaTagParametersBuilder` class for more.

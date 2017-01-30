
## Configure Firebase Database Rules

The Realtime Database provides a declarative rules language that allows you to 
define how your data should be structured, how it should be indexed, and when 
your data can be read from and written to. By default, read and write access 
to your database is restricted so only authenticated users can read or write 
data. To get started without setting up [Authentication](https://firebase.google.com/docs/auth/), 
you can [configure your rules for public access](https://firebase.google.com/docs/database/security/quickstart#sample-rules). 
This does make your database open to anyone, even people not using your app, 
so be sure to restrict your database again when you set up authentication.


### Configuring rules

You can find and change the rules for your database in the [Firebase console](https://console.firebase.google.com/). 
Simply choose your project, click on the Database section on the left, and then
select the Rules tab. If you would like to test your security rules before putting 
them into production, you can simulate operations in the console using the Simulate 
button in the upper right of the rules editor.

You can also update your rules using our [Command Line Interface](https://firebase.google.com/docs/cli/#deployment). 
This is especially useful if you want to update your rules programmatically, 
such as from an automated deployment system.


### Sample rules

By default, your database rules require Firebase Authentication and grant full 
read and write permissions only to authenticated users. The default rules ensure 
your database isn't accessible by just anyone before you get a chance to configure 
it. Once you're set up, you can customize your rules to your needs. 

Here are some common examples:

#### Default 

The default rules require Authentication. They allow full read and write access to 
authenticated users of your app. They are useful if you want data open to all users 
of your app but don't want it open to the world.

```json
// These rules require authentication
{
	"rules": {
		".read": "auth != null",
		".write": "auth != null"
	}
}
```

#### Public 

During development, you can use the public rules in place of the default rules to 
set your files publicly readable and writable. This can be useful for prototyping, 
as you can get started without setting up Authentication. **This level of access 
means anyone can read or write to your database. You should configure more secure 
rules before launching your app.**

```json
// These rules give anyone, even people who are not users of your app,
// read and write access to your database
{
	"rules": {
		".read": true,
		".write": true
	}
}
```


#### User 

Here's an example of a rule that gives each authenticated user a personal node at /users/$user_id where $user_id is the ID of the user obtained through Authentication. This is a common scenario for any apps that have data private to a user.

```json
// These rules grant access to a node matching the authenticated
// user's ID from the Firebase auth token
{
	"rules": {
		"users": {
			"$uid": {
				".read": "$uid === auth.uid",
				".write": "$uid === auth.uid"
			}
		}
	}
}
```


>
> It is essential that you configure these rules correctly before launching your app 
> to ensure that your users can only access the data that they are supposed to.
>


## More Information

For more information read the [Database Rules Guide](https://firebase.google.com/docs/database/security/quickstart)


- Learn more about [securing your data](https://firebase.google.com/docs/database/security/securing-data) using security rules.
- Learn more about [specifying indexes](https://firebase.google.com/docs/database/security/indexing-data) using rules.



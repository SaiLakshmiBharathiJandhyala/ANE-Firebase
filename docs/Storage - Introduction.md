
## Storage

> 
> Firebase Storage is built for app developers who need to store and serve user-generated content, 
> such as photos or videos.
>
> Firebase Storage lets you upload and share user generated content, such as images and video, 
> which allows you to build rich media content into your apps. Firebase Storage stores this 
> data in a Google Cloud Storage bucket, a petabyte scale object storage solution with high 
> availability and global redundancy. Firebase Storage lets you securely upload these files 
> directly from mobile devices and web browsers, handling spotty networks with ease.
>
> Firebase Storage adds Google security to file uploads and downloads for your Firebase apps, 
> regardless of network quality. You can use it to store images, audio, video, or other user-
> generated content. Firebase Storage is backed by Google Cloud Storage, a powerful, simple, 
> and cost-effective object storage service.
>

<iframe width="406" height="228" src="https://www.youtube.com/embed/_tyjqozrEPY?list=PLl-K7zZEsYLmOF_07IayrTntevxtbUxDL" frameborder="0" allowfullscreen></iframe>

[https://firebase.google.com/docs/storage/](https://firebase.google.com/docs/storage/)


## Key capabilities

| | |
|---|---|
| Robust operations   | Firebase Storage performs uploads and downloads regardless of network quality. Uploads and downloads are robust, meaning they restart where they stopped, saving your users time and bandwidth. |
| Strong security | Firebase Storage integrates with Firebase Authentication to provide simple and intuitive authentication for developers. You can use our declarative security model to allow access based on filename, size, content type, and other metadata. |
| High scalability | Firebase Storage is backed by Google Cloud Storage for petabyte scale when your app goes viral. Effortlessly grow from prototype to production using the same infrastructure that powers Snapchat. |


## How does it work?

Developers use the Firebase Storage SDK to upload and download files directly from clients. 
If the network connection is poor, the client is able to retry the operation right where 
it left off, saving your users time and bandwidth.

Firebase Storage stores your files in a [Google Cloud Storage](https://cloud.google.com/storage) 
bucket shared with the default Google App Engine app, making them accessible through 
both Firebase and Google Cloud APIs. 

This allows you the flexibility to upload and download files from mobile clients via 
Firebase and do server-side processing such as image filtering or video transcoding using 
[Google Cloud Platform](https://cloud.google.com/). Firebase Storage scales automatically, 
meaning that there's no need to migrate from Firebase Storage to Google Cloud Storage 
or any other provider. Learn more about all the benefits of our 
[integration with Google Cloud Platform](https://firebase.google.com/docs/storage/gcp-integration).

Firebase Storage integrates seamlessly with Firebase Authentication to identify users, 
and provides a [declarative security language](https://firebase.google.com/docs/storage/security/start) 
that lets you set access controls on individual files or groups of files, so you can 
make files as public or private as you want.


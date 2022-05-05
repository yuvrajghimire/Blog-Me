# BlogMe

BlogMe is an easy blog writing app.

#### Video Demo:  <URL HERE>

#### Description:

BlogMe is a blog writing app which allows users to have basic features to upload a blog and interact with other blogs from different users. It is user friendly and easy to navigate throughout the app. 

I write notes in my phone about different ideas and opinions. I thought it would be nice if I could post it somewhere easily as a blog. So this project came into my mind. This app allows anyone to just share their thoughts with the world.

****

#### About Project:

I chose flutter to develop this app because I was just starting to work with flutter at the same time. I thought I could brush up my skills even more by implementing this project with flutter.

Flutter is an open source development kit developed by the google. It uses dart programming language. Dart is an object oriented programming language. Flutter creates multi-platform or cross platform applications from a single code base. Those platforms include android, ios, linux, mac, web and  windows. It is a growing development environment and daily many developers are choosing this over react native and the native development environment because of its single code base for every platform and also the user interface is the easiest among all.

In this project I have used packages from the pub.dev which I have mentioned below. For the backend and cloud storage I chose Firebase for this project because it was efficient to learn and implement. It is also developed by google. All of the data including images are stored in firebase and accessed by the user whenever needed.

****

#### Project Structure:

So, the place where I write the actual code for development is within the **lib** folder apart from **pubspec.yaml** file which is the project config file. Inside it lies the structure of the project. This project is influenced by the MVC pattern where there are models, controllers(providers) and views(screens/pages).

The root directory has serveral folders and files which are default in a flutter project. It includes 7 folders and 1 dart file (main.dart) within the **lib** folder, i.e
- models
- providers
- resources
- responsive
- screens
- utils
- widgets
- main.dart

**main.dart**: This is the root file of the flutter project. This is where the underlying/root widget lies within which are the other widgets structured like a tree.

**models**: It includes all the models used within the project. Such as user model and post model.

**providers**: This includes 2 files as well but only the user-provider is used currently in the app. It is used to get the userdetails from the auth.

**resources**: This folder includes files where the main services used in this project such as auth service, firestore methods, storage methods. 

**responsive**: This is where the design layouts of the app are. It has 3 files, i.e mobile screen layout, responsive layout and web screen layout. This is for responsive design across the web and mobile platforms.

**screens**: This folder includes 8 files. These are the screens which users sees on their device. These are basically the pages in the app.

**utils**: This folder includes 4 files. These are files that help in storing variables and constants which can be used throughout the app.

**widgets**: This folder includes 5 files. These files are the widgets which are used on several occasions within the project. Such as textfield template, comment template, etc.

****
#### Features: 

The key features are:
- Login / logout
- Create blogs
- Adding pictures
- Categories
- User profile
- Following / followers
- Add/delete posts
- Like
- Comment
- Add tags to the post, etc

****

#### What this project uses:  
1. Development Environment
     - Flutter Development Kit
2. Language
     - Dart
3. Tools used within the project
     - Firebase
     - Provider
     - intl
4. Packages used from pub.dev
     - firebase_auth, firebase_core, firebase_storage, cloud_firestore
     - cached_network_image
     - cupertino_icons
     - shared_preferences
     - intl
     - uuid
     - provider
     - image_picker
     - fluttericon
     - flutter_staggered_grid_view
     - flutter_screenutil
5. Fonts
     - Nunito
6. Colors
     - #183454
     - #183454
     - #ffffff
     - #183454
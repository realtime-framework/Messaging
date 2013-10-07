## The Realtime Framework Pub/Sub messaging system
Part of the [The Realtime® Framework](http://framework.realtime.co), Realtime Cloud Messaging (aka ORTC) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time message broker for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.

## The C sample app
This sample app uses the Realtime® Framework Pub/Sub C library (libortc) to connect, send and receive messages through a Realtime® Server in the cloud.

### Requirements

- CMake >= 2.6 (http://cmake.org/)
- Libwebsockets >= 1.2 (http://libwebsockets.org/)
- libCURL (http://curl.haxx.se)
- POSIX Regular Expressions library
- Pthread library

## Building on Unix

    cd /path/to/src
	mkdir build
	cd build
	cmake ..


>The build/ directory can have any name and be located anywhere on your filesystem and that the argument ".." given to cmake is simply the source directory of libwebsockets containing the CMakeLists.txt project file. All examples assume you use ".."

>A common option you may want to give is to set the install path, same as --prefix= with autotools. 

>It defaults to /usr/local. You can do this by example:


    cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr


>On machines requiring libraries in lib64, you can also add the following to the cmake line -DLIB_SUFFIX=64

Finally you can build using the generated Makefile:


    make

It should generate in your build directory two folders:

- lib (containing libortc dynamic and static)
- example (containing executable example of use the liborc)

## Building on Windows

Generate the Visual Studio project by using the Visual Studio command prompt:

	cd <path to src>
	md build
	cd build
	cmake -G "Visual Studio 10" ..

>There is also a cmake-gui available on Windows if you prefer that

Now you should have a generated Visual Studio Solution in your `<path to src>/build` directory, 
which can be used to build.

You will probably need to install the following dependencies:

- libCURL (http://curl.haxx.se)
- POSIX Regular Expressions library
  - We encourage to use: http://gnuwin32.sourceforge.net/packages/regex.htm
- Pthread library
  - We encourage to use: http://www.sourceware.org/pthreads-win32/


----------

> NOTE: For simplicity these samples assume you're using a Realtime® Framework developers' application key with the authentication service disabled (every connection will have permission to publish and subscribe to any channel). For security guidelines please refer to the [Security Guide](http://messaging-public.realtime.co/documentation/starting-guide/security.html). 
> 
> **Don't forget to replace `YOUR_APPLICATION_KEY` and `YOUR_APPLICATION_PRIVATE_KEY` with your own application key. If you don't already own a free Realtime® Framework application key, [get one now](https://accounts.realtime.co/signup/).**


## Documentation
The complete Realtime® Cloud Messaging reference documentation is available [here](http://framework.realtime.co/messaging/#documentation)
!not-ready-for-release!

#### Version Number
${version-number}

#### New Features

#### Known Issues

#### Breaking Change
- The image has been updated to use the [opensuse-elasticsearch2-image](https://github.com/CAFapi/opensuse-elasticsearch2-image) as its base image. This means that the underlying operating system is now openSUSE and as such any projects consuming this image may require changes to the caller. For example, if the consuming project is using Debian tools like apt-get then updates would be required.
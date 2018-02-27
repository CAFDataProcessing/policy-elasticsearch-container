
#### Version Number
${version-number}

#### New Features
- [SCMOD-3246](https://jira.autonomy.com/browse/SCMOD-3246): Updated elasticsearch settings
#### Known Issues

#### Breaking Change
- The image has been updated to use the [opensuse-elasticsearch2-image](https://github.com/CAFapi/opensuse-elasticsearch2-image) as its base image. This means that the underlying operating system is now openSUSE and as such any projects consuming this image may require changes to the caller. For example, if the consuming project is using Debian tools like apt-get then updates would be required.
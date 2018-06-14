![Program window of Online Sofware / 2](https://github.com/OS2World/APP-INTERNET-Online_Software_2/blob/master/OnlineSoftware2.png)

# APP-INTERNET - Online Software / 2
Desktop application to present applications listed on eCSoft/2.

# License
* GNU GPL V3

# Compile Tools
* DrDialog
* REXX

# Requirements
* RxImgSize (BSD 3-Clause) [https://github.com/OS2World/LIB-REXX-RxImgSize]
* DrCtl017.dll (BSD 3-Clauses alike) [https://www.os2world.com/wiki/index.php/DrDialog_Control]

# Author
Jan-Erik Lärka

...

## Summary
Online Software / 2 is not intended to be an installer (there are plenty already available) itself, but it present you with information about new and updated software from various sources in one place.
It should also (when implemented) be able to launch / download software depending on the installation technique provided with each record.

[First step: Try the binary](https://github.com/OS2World/APP-INTERNET-Online_Software_2/wiki/First-step:-Try-the-binary)

## You as Developer
One of the purposes of this project is to involve you in the process of writing useful rexx scripts and applications for OS/2, eComStation and Arca OS.

[Second step: Development tools](https://github.com/OS2World/APP-INTERNET-Online_Software_2/wiki/Second-step:-Development-tools)

[Third step: Download the project files](https://github.com/OS2World/APP-INTERNET-Online_Software_2/wiki/Third-step:-Download-the-project-files)

## You as User
Another purpose is to create a tool that make you explore software written for OS/2.

### Overview
Online Software / 2 connect to the site eCSoft/2 (http://www.ecsoft2.org) and fetch information about the latest software added to the site. 
The response is formatted as XML and UTF-8 that it has to process.
It follow links to each preview image and full screen image that can be seen for each application/tool/... listed.
Each image are stored to be reopened immediately the next time a record refer to it.
The application display each record with a title, image, a descriptive text, download link and possibly something more.
The title for each record act as a link to the web site page (launch the web browser).

## Prerequisites
DrCtl017.dll - to attach window on window and image viewer (Chris Wolgemuth)
  https://www.os2world.com/wiki/index.php/DrDialog_Control 

rxImgSize - for image processing to retrieve image size (Jan-Erik Lärka)
  https://github.com/OS2World/LIB-REXX-RxImgSize

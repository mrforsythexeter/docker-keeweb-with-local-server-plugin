# Docker Keeweb build with Keeweb-Local-Server plugin

> ⚠️ Use at your own risk

Run a version of keeweb in docker with access to local database files without manually installing the keeweb-local-server plugin

This build is based off the offical build and then modifes the plugin to use a ENV for the password and allows the databases to be bind to the host machine.

This means that your password file could exist anywhere which can be mounted on the host server.

I did this as I couldn't find one to use, that was clear how to use it

## Example docker run line

``docker run -d -p 80:80 -p 443:443 -v .\databases\:/databases/ -e LOCAL_SERVER_PASSWORD='Change this' --name keeweb-local shaunisdocked/keeweb-local-server:latest``

## Disclaimer
The original author repos can be found here [https://github.com/keeweb/keeweb/](https://github.com/keeweb/keeweb/) Thank you for all your work

The base build image can be found here [https://hub.docker.com/r/antelle/keeweb](https://hub.docker.com/r/antelle/keeweb)

The local web plugin author can be found here [https://github.com/vavrecan/keeweb-local-server/](https://github.com/vavrecan/keeweb-local-server/) Thank you for your hard work

I am not responsible for any loss of passwords or curruption of your keefiles.

## Trust no one!
While I have built this to try and take the hard work out of you doing this, study the Dockerfile, understand what I am doing, where I am getting the assets from (above) verify I am not exposing your passwords or capturing your master password.
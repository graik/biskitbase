# biskitbase
A Docker container with all biskit library requirements as well as third-party programs wrapped by biskit (but not biskit itself).

This container is the base layer used by the full biskit docker image graik/biskit. It contains all the dependencies for biskit and 
many of the third-party programs for which there exist biskit wrappers. It **does not** contain biskit itself. 

The project contains an empty folder `downloads`. The docker script will look in this folder for certain third-party installation files that cannot be freely downloaded. See `downloads/README.md` for details.

Note: this container is optimized for running the Python 3.x version of Biskit (branch `biskit3` in the github project).

__Setup__

To re-build it locally run (change the `graik/biskitbase` tag as appropriate):
```sh
git clone https://github.com/graik/biskitbase.git
cd biskitbase
docker build -t graik/biskitbase .
```
Then run the image interactively with:
```sh
docker run -it graik/biskitbase bash
```
Publish it to dockerstore with:
```sh
docker login
docker push graik/biskitbase
```

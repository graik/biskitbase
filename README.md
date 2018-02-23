# biskitbase
A Docker container with all biskit library requirements as well as third-party programs wrapped by biskit.

This container is the base layer used by the full biskit docker image graik/biskit. It contains all the dependencies for biskit and 
many of the third-party programs for which there exist biskit wrappers. It **does not** contain biskit itself. 

To build run:

```
docker build -t graik/biskitbase .
```


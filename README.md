# Jenkins Slave (Docker)
An OpenShift Jenkins slave image built on the OpenShift jenkins Maven slave.
This image adds docker and docker-compose to the image.

## Building
Build and tag the image...

    $ docker-compose build

## Deploying
Here, we'll deploy to the Docker hub. It's free and simple. We just need to
tag our image (with something useful like `2017.1`) and then push it.

    $ docker login -u alanbchristie
    [...]
    $ docker-compose push

---

_Alan B. Christie_  
_December 2017_

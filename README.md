# A Jenkins Docker Slave Image (for OpenShift)
This is a Jenkins slave image built on the OpenShift Jenkins Maven
slave that adds docker and docker-compose to the image. It should be
suitable for OpenShift Origin v3.6 deployments. A matching
image stream template is also included.

>   For background material you can refer to the OpenShift documentation for
    their [Jenkins] service and general information on [builds] and image
    streams.

## Building the image
Build and tag the image (I've successfully used Docker 17.09.0-ce and
docker-compose v1.16.1 to build the image)...

    $ docker-compose build

## Deploying the image
Here, we'll deploy to the Docker hub. It's free and simple. We just need to
tag our image and then push it.

    $ docker login -u alanbchristie
    [...]
    $ docker-compose push

## Using the image as an OpenShift Jenkins slave
To use the image as an OpenShift Jenkins slave you can use the accompanying
`slave.yaml` template file to create a suitable _ImageStream_ using the `oc`
command-line. Assuming you're logged into the OpenShift server and the project
you've into which you've installed Jenkins you can run the following
command to add a suitable image stream.

    $ oc process -f slave.yaml | oc create -f -

This should result in a `docker-slave` _ImageStream_ that can be used as a
source for a Jenkins slave. To employ the image as a slave you refer to is
as the `agent` in your Jenkins _pipeline_ where you'd normally refer to an
agent:

    agent {
      label 'docker-slave'
    }

>   You may need to re-deploy Jenkins (_bounce its Pod_) because it only looks
    for slave-based image streams once, during initialisation. So, if you add a
    slave stream after jenkins was started it'll need to be restarted. When the
    image stream has been recognised you should find it on the
    `Jenkins -> Manage Jenkins -> Configure System` page as a new image
    (with your chosen Name) in the `Kubernetes` section.

>   At the moment I have not solved the _how to actually run docker commands_
    in the container - when I do I'll update this section of the README.

---

_Alan B. Christie_  
_December 2017_

[builds]: https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/builds_and_image_streams.html
[jenkins]: https://docs.openshift.com/container-platform/3.6/using_images/other_images/jenkins.html

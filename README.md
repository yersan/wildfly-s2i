# wildfly-s2i

Wildfly - CentOS Docker images
==============================

This repository contains the source for building 2 different WildFly docker images:

* S2I WildFly builder image. Build a WildFly application as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).
The resulting image can be run using [Docker](http://docker.io).

* WildFly runtime image. An image that contains the minimal dependencies needed to run WildFly with deployed application.
This image is not runnable, it is to be used to chain a build with an image created by the WildFly S2I builder image.

CentOS versions currently provided are:
* CentOS7


Building the images
-------------------

Images are built using docker and [cekit] (version 3) (http://docs.cekit.io/en/latest/).

Cloning the repository:

```
$ git clone https://github.com/wildfly/wildfly-s2i
$ cd wildfly-s2i
```

Building WildFly s2i builder image from scratch:

```
$ cd wildfly-builder-image
$ cekit build docker
```

Building WildFly runtime image from scratch:

```
$ cd wildfly-runtime-image
$ cekit build docker
```

Building on Mac

On Mac, due to some cekit issues, you need to do the build of the 2 images in 2 steps.
cekit will fail but the target/image/Dockerfile is properly generated so you can use docker to build the image.
For example, to build the builder image:

```
$ cd wildfly-builder-image
$ cekit build docker
$ cd target/image
$ docker build -t wildfly/wildfly-170-centos7 .
```

S2I Usage
---------
To build a simple [jee application](https://github.com/openshift/openshift-jee-sample)
using standalone [S2I](https://github.com/openshift/source-to-image) and then run the
resulting image with [Docker](http://docker.io) execute:

```
$ s2i build git://github.com/openshift/openshift-jee-sample wildfly/wildfly-170-centos7 wildflytest
$ docker run -p 8080:8080 wildflytest
```

**Accessing the application:**
```
$ curl 127.0.0.1:8080
```

Chaining s2i build with runtime image
-------------------------------------
The following Dockerfile uses multi-stage build to chain builds to create a lightweight image.

```
FROM wildfly/wildfly-runtime-170-centos7:latest
COPY --from=wildflytest:latest /s2i-output/wildfly $JBOSS_HOME
USER root
RUN chown -R jboss:root $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME
RUN ln -s $JBOSS_HOME /wildfly
USER jboss
CMD $JBOSS_HOME/bin/openshift-launch.sh
```

To build the docker image:
* Copy the Dockerfile content into a `Dockerfile` file
* Adjust the `--from` argument to reference the image you first built with s2i
* In the directory that contains the `Dockerfile` run: `docker build -t wildflytest-rt .`

Test
---------------------
This repository also provides a [S2I](https://github.com/openshift/source-to-image) test framework,
which launches tests to check functionality of a simple WildFly application built on top of the wildfly image.
The tests also create a chained build to build a WildFly application runtime image from an s2i build. 

```
$ make test
```
When running tests, the WildFly docker images are first built.

Repository organization
------------------------

* `imagestreams` contains image streams and templates registered in [openshift library](https://github.com/openshift/library/blob/master/community.yaml)

* `make/` contains make scripts

* `ose3` image streams and templates you can add to a local openshift cluster (eg: `oc create -f ose3/wildfly-s2i-chained-build-template.yml`)
  * `wildfly-builder-image-stream.yml` builder image stream
  * `wildfly-runtime-image-stream.yml` runtime image stream
  * `wildfly-s2i-chained-build-template.yml` template that build an application using s2i and copy the WildFly server and deployed app inside the WildFly runtime image.

* `test/` contains test applications and make test `run` script

* `wildfly-builder-image/` contains builder image yaml file

* `wildfly-modules/` contains cekit modules specific to wildfly. NB: These modules are progressively removed and added to the [wildfly-cekit-modules](http://github.com/wildfly/wildfly-cekit-modules) repository.

* `wildfly-runtime-image/` contains runtime image yaml file

Hot Deploy
------------------------

Hot deploy is enabled by default for all WildFly versions.
To deploy a new version of your web application without restarting, you will need to either rsync or scp your war/ear/rar/jar file to the /wildfly/standalone/deployments directory within your pod.

Image name structure
------------------------
##### Structure: openshift/3

1. Platform name (lowercase) - wildfly
2. Platform version(without dots) - 170
3. Base builder image - centos7

Example: `wildfly/wildfly-170-centos7`

Environment variables to be used with the WildFly s2i builder image
-------------------------------------------------------------------

To set environment variables, you can place them as a key value pair into a `.s2i/environment`
file inside your source code repository.

* GALLEON_PROVISION_SERVER

    The image contains a set of pre-defined galleon definitions that you can use to provision a custom WildFly server during s2i build.
    The set of built-in descriptions are:
     * TODO, add the ones we actually deliver.

* MAVEN_ARG

    Overrides the default arguments passed to maven during the build process

* MAVEN_ARGS_APPEND

    This value will be appended to either the default maven arguments, or the value of MAVEN_ARGS if MAVEN_ARGS is set.

* MAVEN_OPTS

    Contains JVM parameters to maven.  Will be appended to JVM arguments that are calculated by the image
    itself (e.g. heap size), so values provided here will take precedence.

* JAVA_GC_OPTS

    When set to a non-null value, this value will be passed to the JVM instead of the default garbage collection tuning
    values defined by the image.

* CONTAINER_CORE_LIMIT

    When set to a non-null value, the number of parallel garbage collection threads will be set to this value.

* USE_JAVA_DIAGNOSTICS

    When set to a non-null value, various JVM related diagnostics will be turned on such as verbose garbage
    collection tracing.

* AUTO_DEPLOY_EXPLODED

    When set to `true`, Wildfly will automatically deploy exploded war content.  When unset or set to `false`,
    a `.dodeploy` file must be touched to trigger deployment of exploded war content.

* MYSQL_DATABASE

    If set, WildFly will attempt to define a MySQL datasource based on the assumption you have an OpenShift service named "mysql" defined.
    It will attempt to reference the following environment variables which are automatically defined if the "mysql" service exists:
    MYSQL_SERVICE_PORT
    MYSQL_SERVICE_HOST
    MYSQL_PASSWORD
    MYSQL_USER

* POSTGRESQL_DATABASE

    If set, WildFly will attempt to define a PostgreSQL datasource based on the assumption you have an OpenShift service named "postgresql" defined.
    It will attempt to reference the following environment variables which are automatically defined if the "postgresql" service exists:
    POSTGRESQL_SERVICE_PORT
    POSTGRESQL_SERVICE_HOST
    POSTGRESQL_PASSWORD
    POSTGRESQL_USER

Known issues
--------------------

**UTF-8 characters not displayed (or displayed as ```?```)**

This can be solved by providing to the JVM the file encoding. Set variable ```MAVEN_OPTS=-Dfile.encoding=UTF-8``` into the build variables


Copyright
--------------------

Released under the Apache License 2.0. See the [LICENSE](LICENSE) file.

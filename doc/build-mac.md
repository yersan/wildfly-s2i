Building on Mac
===============

* Installing Docker
 * Install [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-mac)

* Installing Python (required by cekit)
 * Install [python 3](https://www.python.org)
 * Install virtualenv: `sudo pip3 install virtualenv`
 * Create a directory for the cekit virtualenv: `mkdir my-vertualenv`
 * Create the virtualenv: `virtualenv my-vertualenv/cekit`
 * Activate the virtualenv `source my-vertualenv/cekit/bin/activate`

* Installing cekit and dependencies
  * `pip3 install cekit`
  * `pip3 install docker`
  * `pip3 install docker_squash`

You are ready to build WildFly images using cekit!
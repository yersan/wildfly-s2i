# wildfly-s2i

Build both images and run tests
===============================

make test
==> Image openshift/wildfly-170-centos7 and openshift/wildfly-runtime-170-centos7 created

Build builder image
===================
cd wildfly-builder-image
cekit build docker

==> Image openshift/wildfly-170-centos7 created

Build runtime image
===================
cd wildfly-runtime-image
cekit build docker

==> Image openshift/wildfly-runtime-170-centos7 created


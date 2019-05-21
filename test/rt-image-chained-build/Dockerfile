FROM openshift/wildfly-170-centos7:latest
COPY --from=openshift/wildfly-170-centos7-testapp:latest /s2i-output/wildfly $JBOSS_HOME
USER root
RUN chown -R jboss:root $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME
USER jboss
CMD $JBOSS_HOME/bin/openshift-launch.sh

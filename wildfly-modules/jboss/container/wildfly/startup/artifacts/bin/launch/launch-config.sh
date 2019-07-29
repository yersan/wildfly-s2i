#!/bin/sh
# Openshift WildFly runtime configuration update
# Centralised configuration file to set variables that affect the launch scripts in wildfly-cekit-modules.

# Scripts that 
# wildfly-cekit-modules will look for each of the listed files and run them if they exist.
CONFIG_SCRIPT_CANDIDATES=(
  $JBOSS_HOME/bin/launch/datasource.sh
  $JBOSS_HOME/bin/launch/json_logging.sh
  $JBOSS_HOME/bin/launch/keycloak.sh
  $JBOSS_HOME/bin/launch/mp-config.sh
  $JBOSS_HOME/bin/launch/mysql.sh
  $JBOSS_HOME/bin/launch/postgresql.sh
  $JBOSS_HOME/bin/launch/tracing.sh
  $JBOSS_HOME/bin/launch/https.sh
  $JBOSS_HOME/bin/launch/security-domains.sh
  $JBOSS_HOME/bin/launch/elytron.sh
  /opt/run-java/proxy-options
  $JBOSS_HOME/bin/launch/jboss_modules_system_pkgs.sh
)

# Notice that the value of this variable must be aligned with the value configured in s2i-core-hooks
CONFIG_ADJUSTMENT_MODE="cli"
if [ -z "${DISABLE_GENERATE_DEFAULT_DATASOURCE}" ] ; then
  DISABLE_GENERATE_DEFAULT_DATASOURCE=true
fi

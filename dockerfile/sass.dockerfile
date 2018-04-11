FROM jeff1evesque/ml-base:0.7

## local variables
ENV ENVIRONMENT docker
ENV PUPPET /opt/puppetlabs/bin/puppet
ENV ROOT_PROJECT /var/machine-learning
ENV ROOT_PUPPET /etc/puppetlabs
ENV MODULES $ROOT_PUPPET/code/modules
ENV CONTRIB_MODULES $ROOT_PUPPET/code/modules_contrib

## source and asset directory
RUN mkdir -p $ROOT_PROJECT/interface/static $ROOT_PROJECT/src/scss

## copy files into container
COPY src/scss $ROOT_PROJECT/src/scss
COPY hiera /var/machine-learning/hiera
COPY puppet/environment/$ENVIRONMENT/modules/sass $ROOT_PUPPET/code/modules/sass

##
## manual build workaround
##
## https://github.com/jeff1evesque/machine-learning/issues/2935#issuecomment-378086431
##
RUN npm install -g --unsafe-perm node-sass@4.8.3

## provision with puppet
RUN $PUPPET apply -e 'class { sass: run => false }' --modulepath=$CONTRIB_MODULES:$MODULES --confdir=$ROOT_PUPPET/puppet

## executed everytime container starts
CMD ["/bin/sh", "-c", "sass"]
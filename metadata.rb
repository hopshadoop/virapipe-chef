name             "virapipe"
maintainer       "Jim Dowling"
maintainer_email "jdowling@kth.se"
license          "Apache v2.0"
description      "Installs/Configures the Virapipe plaform for Hops Hadoop."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"
source_url       "https://github.com/hopshadoop/virapipe-chef"


%w{ ubuntu debian centos rhel }.each do |os|
  supports os
end

depends 'conda'
depends 'kagent'
depends 'hops'

recipe  "virapipe::install", "Installs Virapipe"
recipe  "virapipe::default", "Configures Virapipe."

#######################################################################################
# Required Attributes
#######################################################################################

attribute "java/jdk_version",
          :display_name =>  "Jdk version",
          :type => 'string'

attribute "java/install_flavor",
          :display_name =>  "Oracle (default) or openjdk",
          :type => 'string'



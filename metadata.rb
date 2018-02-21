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

depends 'java'
depends 'magic_shell'
depends 'kagent'
depends 'conda'
depends 'hops'
depends 'ndb'
depends 'kzookeeper'

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

attribute "hops/base_dir",
          :display_name =>  "Hops base install dir",
          :type => 'string'

attribute "hops/yarnapp/user",
          :display_name =>  "Hops yarn app user",
          :type => 'string'

attribute "install/dir",
          :description => "Default ''. Set to a base directory under which all hops services will be installed.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

attribute "install/ssl",
          :description => "Is SSL turned on for all services?",
          :type => "string"

attribute "install/cleanup_downloads",
          :description => "Remove any zipped binaries that were downloaded and used to install services",
          :type => "string"

attribute "download_url",
          :description => "URL for downloading binaries",
          :type => 'string'

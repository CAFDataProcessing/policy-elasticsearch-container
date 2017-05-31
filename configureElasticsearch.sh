#!/bin/bash
#
# Copyright 2015-2017 Hewlett Packard Enterprise Development LP.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


####################################################
####################################################
# Default Elasticsearch configuration files
####################################################
####################################################
elasticsearchConfigFile="/opt/elasticsearchConfig/elasticsearch.yml"
elasticsearchLoggingFile="/opt/elasticsearchConfig/logging.yml"


####################################################
####################################################
# Utility funcs
####################################################
####################################################

####################################################
# Get access to environment 
# vars which include dots or non-alphas in the name.
####################################################
function get_env_var() {
   local variableName="${1:-}" ; shift

   # helpful debug.
   # echo 'requesting environment variable name:' $variableName   
   # perl -le 'print $ENV{'$variableName'}';
   
   result=$(perl -le 'print $ENV{"'$variableName'"};')
}

####################################################
# Sets the elasticsearch config file path to the
# mesos mount if the file exists there.
####################################################
function set_elasticsearch_config_file_location_if_mounted(){

  if [ -e "/mnt/mesos/sandbox/elasticsearch.yml" ]
  then
    elasticsearchConfigFile="/mnt/mesos/sandbox/elasticsearch.yml"
    echo "Detected mesos Elasticsearch config location: " $elasticsearchConfigFile
  else
    echo "Uses default Elasticsearch config location: " $elasticsearchConfigFile
  fi
}

####################################################
# Sets the elasticsearch config file path according
# to environment property if present and found on
# disk, otherwise fallback to the mesos mount if the
# file exists there.
####################################################
function set_elasticsearch_config_file_location(){

    get_env_var "ELASTICSEARCH_CONFIG_FILE"

    # test if we got anything from this environment option if so check it exists,
    # if so use it now instead of default.
    [[ -n "$result" ]] && {

        if [ -e "$result" ]
        then
            echo "Detected Elasticsearch config file location as: " $result
            elasticsearchConfigFile="$result"
            return;
        fi
    }

    # otherwise use fallback mesos directory if mounted.
    set_elasticsearch_config_file_location_if_mounted
}

####################################################
# Sets the elasticsearch logging file path to the
# mesos mount if the file exists there.
####################################################
function set_elasticsearch_logging_file_location_if_mounted(){

  if [ -e "/mnt/mesos/sandbox/logging.yml" ]
  then
    elasticsearchLoggingFile="/mnt/mesos/sandbox/logging.yml"
    echo "Detected mesos Elasticsearch logging file location: " $elasticsearchLoggingFile
  else
    echo "Uses default Elasticsearch logging file location: " $elasticsearchLoggingFile
  fi
}

####################################################
# Sets the elasticsearch logging file path according
# to environment property if present and found on
# disk, otherwise fallback to the mesos mount if the
# file exists there.
####################################################
function set_elasticsearch_logging_file_location(){

    get_env_var "ELASTICSEARCH_LOGGING_FILE"

    # test if we got anything from this environment option if so check it exists,
    # if so use it now instead of default.
    [[ -n "$result" ]] && {

        if [ -e "$result" ]
        then
            echo "Detected Elasticsearch logging file location as: " $result
            elasticsearchLoggingFile="$result"
            return;
        fi
    }

    # otherwise use fallback mesos directory if mounted.
    set_elasticsearch_logging_file_location_if_mounted
}


####################################################
# Allow elasticsearch user unlimited memlock
# as required by Elasticsearch
####################################################
function configure_elasticsearch_user_for_memlock(){

    sed -i '$ i\
    elasticsearch soft memlock unlimited\
    elasticsearch hard memlock unlimited
    ' /etc/security/limits.conf
}


####################################################
# Move the supplied Elasticsearch configuration file
####################################################
function replace_elasticsearch_config_file(){

    set_elasticsearch_config_file_location
    mv -f ${elasticsearchConfigFile} /etc/elasticsearch/elasticsearch.yml
}


####################################################
# Move the supplied Elasticsearch logging file
####################################################
function replace_elasticsearch_logging_file(){

    set_elasticsearch_logging_file_location
    mv -f ${elasticsearchLoggingFile} /etc/elasticsearch/logging.yml
}


####################################################
####################################################
# Configure Elasticsearch
####################################################
####################################################

configure_elasticsearch_user_for_memlock
replace_elasticsearch_config_file
replace_elasticsearch_logging_file

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#set this to an absolute path that exist on every machine
HADOOP_PREFIX={{ hadoop_prefix }}
ACCUMULO_HOME={{ accumulo_prefix }}
JAVA_HOME={{ java_home }}
ZOOKEEPER_HOME={{ zookeeper_prefix }}

CONTINUOUS_LOG_DIR=/var/log/accumulo/continuous-test
INSTANCE_NAME={{ instance_name }}
ZOO_KEEPERS={{ zookeeper_host }}
USER=root
PASS={{ secret }}
TABLE=ci

#set debug to on to enable logging of accumulo client debugging
DEBUG_INGEST=off
DEBUG_WALKER=off
DEBUG_BATCH_WALKER=off
DEBUG_SCANNER=off

#the number of entries each client should write
NUM=9223372036854775807

#the minimum random row to generate
MIN=0

#the maximum random row to generate
MAX=9223372036854775807

#the maximum number of random column families to generate
MAX_CF=32767

#the maximum number of random column qualifiers to generate
MAX_CQ=32767

#an optional file in hdfs containing visibilites.  If left blank, then column
#visibility will not be set.  If specified then a random line will be selected
#from the file and used for column visibility for each linked list.
VISIBILITIES=''

#the max memory (in bytes) each ingester will use to buffer writes
MAX_MEM=100000000

#the maximum time (in millis) each ingester will buffer data
MAX_LATENCY=600000

#the number of threads each ingester will use to write data
NUM_THREADS=4

#the amount of time (in millis) to sleep between each query
SLEEP_TIME=10

#an optional file in hdfs containing line of comma seperated auths.  If
#specified, walkers will randomly select lines from this file and use that to
#set auths.
AUTHS=''

#time amount of time (in minutes) the agitator should sleep before killing
KILL_SLEEP_TIME=20

#time amount of time (in minutes) the agitator should sleep after killing before running tup 
TUP_SLEEP_TIME=10

#determines if checksum are generated, may want to turn of when performance testing
CHECKSUM=true

#the minimum and maximum server the agitator will kill at once
MIN_KILL=1
MAX_KILL=1

#time in minutes between killing masters
MASTER_KILL_SLEEP_TIME=60
MASTER_RESTART_SLEEP_TIME=2

#settings for the verification map reduce job
VERFIY_OUT=/tmp/continuous_verify
VERIFY_MAX_MAPS=64
VERIFY_REDUCERS=64
SCAN_OFFLINE=false
#comma separated list of auths to use for verify
VERIFY_AUTHS=''

#settings related to the batch walker
BATCH_WALKER_SLEEP=180000
BATCH_WALKER_BATCH_SIZE=10000
BATCH_WALKER_THREADS=16

#settings related to scanners
SCANNER_SLEEP_TIME=10
SCANNER_ENTRIES=5000
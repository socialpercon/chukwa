#!/bin/sh
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

pid=$$

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`
. "$bin"/chukwa-config.sh

if [ "$CHUKWA_IDENT_STRING" = "" ]; then
  export CHUKWA_IDENT_STRING="$USER"
fi



trap 'rm -f $CHUKWA_PID_DIR/chukwa-$CHUKWA_IDENT_STRING-postProcess.sh.pid ${CHUKWA_PID_DIR}/PostProcessorManager.pid; exit 0' 1 2 15
echo "${pid}" > "$CHUKWA_PID_DIR/chukwa-$CHUKWA_IDENT_STRING-postProcess.sh.pid"


if [ "X$1" = "Xstop" ]; then
  echo -n "Shutting down postProcess.sh..."
  kill -TERM `cat ${CHUKWA_PID_DIR}/PostProcessorManager.pid`
  echo "done"
  exit 0
fi

# run PosProcessorManager
${JAVA_HOME}/bin/java -Djava.library.path=${JAVA_LIBRARY_PATH} -DCHUKWA_HOME=${CHUKWA_HOME} -DCHUKWA_CONF_DIR=${CHUKWA_CONF_DIR} -DCHUKWA_LOG_DIR=${CHUKWA_LOG_DIR} -DAPP=postProcess -Dlog4j.configuration=chukwa-log4j.properties -classpath ${CHUKWA_CONF_DIR}:${CLASSPATH}:${CHUKWA_CORE}:${HADOOP_JAR}:${COMMON}:${tools} org.apache.hadoop.chukwa.extraction.demux.PostProcessorManager 


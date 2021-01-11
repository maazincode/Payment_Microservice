#!/bin/bash
set -e

pushd code-with-quarkus
mvn package -Dquarkus.package.type=uber-jar

# Start the server in the background so that the
# shell script is not blocked and can execute the tests
java -jar target/code-with-quarkus-1.0.0-SNAPSHOT-runner.jar &

# Remember the process id of the server process
# so that we can shutdown the server after the tests
# are run.
# Later, when we use docker, we are going to have better
# options available.
server_pid=$!

# Install a hook that on err or on normal exit of this script,
# the server is killed, so that we can run the script again
trap 'kill $server_pid' err exit

popd

# Give the Web server a chance to finish start up
sleep 2s 

#pushd demo_client
#mvn test
#popd

#!/bin/bash -i

echo "here"
if [ -z "$branch_specifier" ]; then
    # manual
    IMAGE_NAME="logstash-integration-tests"
else
    # Jenkins
    IMAGE_NAME=$branch_specifier"-"$(date +%s%N)
fi

echo "Running CI build for '$IMAGE_NAME' "

docker build  -t $IMAGE_NAME .
exit_code=$?; [[ $exit_code != 0 ]] && exit $exit_code
docker run -t --rm $IMAGE_NAME ci/integration_tests.sh
exit_code=$?
[[ $IMAGE_NAME = "logstash-integration-tests" ]] && docker rmi $IMAGE_NAME
exit $exit_code #preserve the exit code from the test run

#Note - ensure that the -e flag is NOT set, and explicitly check the $? status to allow for clean up
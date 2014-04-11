#!/bin/bash -e
# run-job.sh expects the REPO_NAME env variable

function run_test {
  ruby1.9.3 /usr/bin/bundle install --path=.bundle
  ruby1.9.3 /usr/bin/bundle exec berks install --path=.cookbooks
  if ! ( ruby1.9.3 /usr/bin/bundle exec kitchen test ); then
    echo "test-kitchen job did not complete successfully, cleaning up"
    ruby1.9.3 /usr/bin/bundle exec kitchen destroy all
    RET=1
  fi
}

RET=0

pushd ${GIT_PATH}
run_test
popd

exit $RET


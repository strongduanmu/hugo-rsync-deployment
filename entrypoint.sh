#!/bin/sh -l

set -euo pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

mkdir -p "${HOME}/.ssh"
cat ${DEPLOY_KEY}
echo "${DEPLOY_KEY}" > "${HOME}/.ssh/id_rsa_deploy"
chmod 600 "${HOME}/.ssh/id_rsa_deploy"
  
  
#eg: "doc1 doc2"
doc_dirs=$1

for dir in `echo ${doc_dirs}`; do
  cd "${GITHUB_WORKSPACE}/${dir}"

  hugo version
  hugo $2

  rsync --version
  sh -c "
    rsync $3 \
    -e 'ssh -i ${HOME}/.ssh/id_rsa_deploy -o StrictHostKeyChecking=no' \
    ${GITHUB_WORKSPACE}/${dir}/public \
    ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_DEST}/${dir}
  "

done;

exit 0

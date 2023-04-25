#!/bin/sh -l

set -euo pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

export HOME="/home/appuser"
mkdir -p "${HOME}/.ssh"

echo "${DEPLOY_KEY}" > /github/workspace/pubkey
echo "${DEPLOY_KEY}" > "${HOME}/.ssh/id_rsa_deploy"
chmod 600 "${HOME}/.ssh/id_rsa_deploy"
  
  
#eg: "doc1 doc2"
doc_version=$1
doc_dirs=$2
doc_domain=$3

export ZH_VER_DIR="content.zh/${doc_version}"
export EN_VER_DIR="content/${doc_version}"
export VERSION="${doc_version}"
export DOC_DOMAIN="${doc_domain}"

for dir in ${doc_dirs}; do
  #chown 1000:1000 -R "${GITHUB_WORKSPACE}/${dir}"
  cd "${GITHUB_WORKSPACE}/${dir}"
  envsubst < "config.toml.template" > config.toml
  cat config.toml
  
  hugo version
  hugo $4
  
  #chown 1000:1000 -R "${GITHUB_WORKSPACE}/${dir}"

  ssh -i ${HOME}/.ssh/id_rsa_deploy -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} "mkdir -p ${DEPLOY_DEST}/${dir}/${VERSION}"
  rsync --version
  sh -c "
    rsync $5 \
    -e 'ssh -i ${HOME}/.ssh/id_rsa_deploy -o StrictHostKeyChecking=no' \
    ${GITHUB_WORKSPACE}/${dir}/public/ \
    ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_DEST}/${dir}/${VERSION}
  "

done;

exit 0

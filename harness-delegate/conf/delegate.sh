#!/bin/bash -e

sudo docker pull harness/delegate:latest

sudo docker run -d --restart unless-stopped --hostname=$(hostname -f) \
-e ACCOUNT_ID=Cu_0_Hw6RbKRL9QT-0DjKw \
-e ACCOUNT_SECRET=730f5a74d25c8ac877d1e095653b031e \
-e MANAGER_HOST_AND_PORT=https://app.harness.io/gratis \
-e WATCHER_STORAGE_URL=https://app.harness.io/storage/wingswatchers \
-e WATCHER_CHECK_LOCATION=watcherprod.txt \
-e DELEGATE_STORAGE_URL=https://app.harness.io/storage/wingsdelegates \
-e DELEGATE_CHECK_LOCATION=delegatefree.txt \
-e DEPLOY_MODE=KUBERNETES \
-e PROXY_HOST= \
-e PROXY_PORT= \
-e PROXY_SCHEME= \
-e PROXY_USER= \
-e PROXY_PASSWORD= \
-e NO_PROXY= \
-e PROXY_MANAGER=true \
-e POLL_FOR_TASKS=false \
-e HELM_DESIRED_VERSION= \
harness/delegate:latest
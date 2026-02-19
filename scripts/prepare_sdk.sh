#!/usr/bin/env bash
# prepare_sdk.sh
# author: seung hee, lee
# purpose: prepare sdk environment (idf.py)

cur_path=${PWD}
if [[ "$OSTYPE" == "darwin"* ]]; then
    project_path=$(dirname $(dirname $(realpath $0)))
else 
    project_path=$(dirname $(dirname $(realpath $BASH_SOURCE)))
fi
# sdk_path=${project_path}/sdk
sdk_path=/media/patrik/nvm/matter-esp32-ws2812-sdk/tools  # change to your own sdk path
esp_idf_path=${sdk_path}/esp-idf
esp_matter_path=${sdk_path}/esp-matter
chip_path=${esp_matter_path}/connectedhomeip/connectedhomeip
zap_path=${chip_path}/.environment/cipd/packages/zap

# Avoid conflicts with an already-exported ESP-IDF environment from
# a different checkout in the same shell.
unset IDF_PATH
unset IDF_TOOLS_PATH
unset IDF_PYTHON_ENV_PATH

if ! [ -f "${esp_idf_path}/export.sh" ]; then
  echo "ERROR: Missing ${esp_idf_path}/export.sh"
  return 1 2>/dev/null || exit 1
fi
if ! [ -f "${esp_matter_path}/export.sh" ]; then
  echo "ERROR: Missing ${esp_matter_path}/export.sh"
  return 1 2>/dev/null || exit 1
fi

export IDF_PATH=${esp_idf_path}
source ${esp_idf_path}/export.sh
source ${esp_matter_path}/export.sh
export IDF_CCACHE_ENABLE=1

# (optional) print git commit id of repositories
echo "------------------------------------------------------"
echo "[esp-idf]"
cd ${esp_idf_path}
git rev-parse HEAD
git describe --tags
echo "[esp-matter]"
cd ${esp_matter_path}
git rev-parse HEAD
git describe --tags
echo "[connectedhomeip]"
cd ${chip_path}
git rev-parse HEAD
git describe --tags
echo "[zap-cli]"
cd ${zap_path}
./zap-cli --version
echo "------------------------------------------------------"

cd ${cur_path}

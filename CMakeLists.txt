cmake_minimum_required(VERSION 3.16)

if(NOT DEFINED ENV{ESP_MATTER_PATH} OR "$ENV{ESP_MATTER_PATH}" STREQUAL "")
    set(_esp_matter_candidates
        "${CMAKE_CURRENT_LIST_DIR}/sdk/esp-matter"
        "${CMAKE_CURRENT_LIST_DIR}/../esp-matter"
    )
    foreach(_cand IN LISTS _esp_matter_candidates)
        if(EXISTS "${_cand}/examples/common" AND EXISTS "${_cand}/device_hal/device/esp32_devkit_c")
            set(ENV{ESP_MATTER_PATH} "${_cand}")
            break()
        endif()
    endforeach()
endif()

if(NOT DEFINED ENV{ESP_MATTER_PATH} OR "$ENV{ESP_MATTER_PATH}" STREQUAL "")
    message(FATAL_ERROR "ESP_MATTER_PATH is not set and no local esp-matter checkout was found.")
endif()

if(NOT DEFINED ENV{_PW_ACTUAL_ENVIRONMENT_ROOT} OR "$ENV{_PW_ACTUAL_ENVIRONMENT_ROOT}" STREQUAL "")
    set(_pw_env_root "$ENV{ESP_MATTER_PATH}/connectedhomeip/connectedhomeip/.environment")
    if(EXISTS "${_pw_env_root}/build_overrides/pigweed_environment.gni")
        set(ENV{_PW_ACTUAL_ENVIRONMENT_ROOT} "${_pw_env_root}")
    endif()
endif()

set(_esp_matter_device "esp32_devkit_c")
if(IDF_TARGET STREQUAL "esp32s3")
    set(_esp_matter_device "esp32s3_devkit_c")
endif()
set(ENV{ESP_MATTER_DEVICE_PATH} "$ENV{ESP_MATTER_PATH}/device_hal/device/${_esp_matter_device}")
set(PROJECT_VER "1.0.0.0")
set(PROJECT_VER_NUMBER 20230529)

set(ESP_MATTER_PATH $ENV{ESP_MATTER_PATH})
set(MATTER_SDK_PATH ${ESP_MATTER_PATH}/connectedhomeip/connectedhomeip)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
include($ENV{ESP_MATTER_DEVICE_PATH}/esp_matter_device.cmake)

set(EXTRA_COMPONENT_DIRS
    "${ESP_MATTER_PATH}/examples/common"
    "${MATTER_SDK_PATH}/config/esp32/components"
    "${ESP_MATTER_PATH}/components"
    "${ESP_MATTER_PATH}/device_hal/device"
    ${extra_components_dirs_append}
)

project(yogyui-matter-esp32-ws2812)
idf_build_set_property(CXX_COMPILE_OPTIONS "-std=gnu++17;-Os" APPEND)
idf_build_set_property(CXX_COMPILE_OPTIONS "-Os" APPEND)
idf_build_set_property(CXX_COMPILE_OPTIONS "-DCHIP_HAVE_CONFIG_H" APPEND)
idf_build_set_property(CXX_COMPILE_OPTIONS "-fpermissive" APPEND)
idf_build_set_property(C_COMPILE_OPTIONS "-Os" APPEND)
idf_build_set_property(COMPILE_OPTIONS "-Wno-unused-function" APPEND)
idf_build_set_property(COMPILE_OPTIONS "-Wno-format-nonliteral" APPEND)
idf_build_set_property(COMPILE_OPTIONS "-Wno-format-security" APPEND)
idf_build_set_property(COMPILE_OPTIONS "-Wformat=0" APPEND)
idf_build_set_property(COMPILE_OPTIONS "-Wno-error=maybe-uninitialized" APPEND)

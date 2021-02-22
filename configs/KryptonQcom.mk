# Copyright 2021 AOSP-Krypton Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Board platforms
QCOM_MSMNILE := sm8150 msmnile
QCOM_MSM8998 := sdm660

ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(QCOM_MSMNILE)),)
QCOM_BOARD_PATH := sm8150
else ifneq ($(filter $(TARGET_BOARD_PLATFORM),$(QCOM_MSM8998)),)
QCOM_BOARD_PATH := msm8998
endif

# Build libOmx encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Get relative path for caf stuff
get-caf-path = hardware/qcom-caf/$(QCOM_BOARD_PATH)/$(1)

# Include caf wlan in cfi path
PRODUCT_CFI_INCLUDE_PATHS += \
    hardware/qcom-caf/wlan/qcwcn/wpa_supplicant_8_lib

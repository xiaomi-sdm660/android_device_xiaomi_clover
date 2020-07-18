#
# Copyright (C) 2018 The Xiaomi-SDM660 Project
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

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.audio.fluence.audiorec=true

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.stats.test=5 \
    persist.camera.HAL3.enabled=1 \
    persist.camera.preview.ubwc=0

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    debug.vds.allow_hwc=0

# Lockscreen rotation (requested by ibooth2004@XDA (https://forum.xda-developers.com/showpost.php?p=82157253&postcount=545)
PRODUCT_PROPERTY_OVERRIDES += \
    lockscreen.rot_override=true

# Single SIM
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=ssss

# Ultra Sound
PRODUCT_PROPERTY_OVERRIDES += \
    audio.chk.cal.us=0

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
	ro.vendor.audio.sdk.fluencetype=fluence \
	persist.vendor.audio.fluence.voicecall=true \
	persist.vendor.audio.fluence.voicerec=true \
	persist.vendor.audio.fluence.speaker=true \
	persist.vendor.audio.fluence.audiorec=true \
	vendor.audio.adm.buffering.ms=3 \
	vendor.audio.offload.track.enable=true

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
	persist.radio.VT_CAM_INTERFACE=1 \
	persist.camera.stats.test=5

# Display
PRODUCT_PROPERTY_OVERRIDES += \
	debug.sf.recomputecrop=0 \
	debug.vds.allow_hwc=0

# Media
PRODUCT_PROPERTY_OVERRIDES += \
	mm.enable.qcom_parser=13631487

# System property for color temperature
PRODUCT_PROPERTY_OVERRIDES += \
	ro.colorpick_adjust=true \
	ro.df.effect.conflict=1

# Single SIM
PRODUCT_PROPERTY_OVERRIDES += \
	persist.radio.multisim.config=ssss

# Ultra Sound
PRODUCT_PROPERTY_OVERRIDES += \
	audio.chk.cal.us=0


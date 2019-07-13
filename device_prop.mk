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

# ACDB
PRODUCT_PROPERTY_OVERRIDES += \
	persist.audio.calfile0=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_Bluetooth_cal.acdb \
	persist.audio.calfile1=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_General_cal.acdb \
	persist.audio.calfile2=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_Global_cal.acdb \
	persist.audio.calfile3=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_Handset_cal.acdb \
	persist.audio.calfile4=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_Hdmi_cal.acdb \
	persist.audio.calfile5=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_Headset_cal.acdb \
	persist.audio.calfile6=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_Speaker_cal.acdb \
	persist.audio.calfile7=/vendor/etc/acdbdata/QRD/sdm660-snd-card-skush/QRD_SKUSH_workspaceFile.qwsp \
	persist.audio.calfile8=/vendor/etc/acdbdata/adsp_avs_config.acdb \
	persist.audio.calfile0D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_Bluetooth_cal.acdb \
	persist.audio.calfile1D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_General_cal.acdb \
	persist.audio.calfile2D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_Global_cal.acdb \
	persist.audio.calfile3D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_Handset_cal.acdb \
	persist.audio.calfile4D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_Hdmi_cal.acdb \
	persist.audio.calfile5D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_Headset_cal.acdb \
	persist.audio.calfile6D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_Speaker_cal.acdb \
	persist.audio.calfile7D9P=/vendor/etc/acdbdata/QRD/sdm660-snd-card-d9p/QRD_D9P_workspaceFile.qwsp \
	persist.audio.calfile8D9P=/vendor/etc/acdbdata/adsp_avs_config.acdb

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

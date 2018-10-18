#
# Copyright (C) 2018 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

NEW_BOOTIMAGE_ARGS := $(subst --kernel $(INSTALLED_KERNEL_TARGET),--kernel $(TARGET_PREBUILT_KERNEL),$(INTERNAL_BOOTIMAGE_ARGS))
NEW_RECOVERYIMAGE_ARGS := $(subst --kernel $(recovery_kernel),--kernel $(TARGET_PREBUILT_KERNEL),$(INTERNAL_RECOVERYIMAGE_ARGS))

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(NEW_BOOTIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo "Made boot image: $@"

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(NEW_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --id > $(RECOVERYIMAGE_ID_FILE)
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo "Made recovery image: $@"

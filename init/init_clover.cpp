/*
#
# Copyright 2018 The Android Open Source Project
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
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <android-base/file.h>
#include <android-base/properties.h>
#include <android-base/strings.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;
using android::base::ReadFileToString;
using android::base::Trim;
using android::init::property_set;

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_dual(char const system_prop[],
        char const vendor_prop[], char const value[])
{
    property_override(system_prop, value);
    property_override(vendor_prop, value);
}

static void init_alarm_boot_properties()
{
    char const *boot_reason_file = "/proc/sys/kernel/boot_reason";
    char const *power_off_alarm_file = "/persist/alarm/powerOffAlarmSet";
    std::string boot_reason;
    std::string power_off_alarm;
    std::string reboot_reason = GetProperty("ro.boot.alarmboot", "");

    if (ReadFileToString(boot_reason_file, &boot_reason)
            && ReadFileToString(power_off_alarm_file, &power_off_alarm)) {
        /*
         * Setup ro.alarm_boot value to true when it is RTC triggered boot up
         * For existing PMIC chips, the following mapping applies
         * for the value of boot_reason:
         *
         * 0 -> unknown
         * 1 -> hard reset
         * 2 -> sudden momentary power loss (SMPL)
         * 3 -> real time clock (RTC)
         * 4 -> DC charger inserted
         * 5 -> USB charger inserted
         * 6 -> PON1 pin toggled (for secondary PMICs)
         * 7 -> CBLPWR_N pin toggled (for external power supply)
         * 8 -> KPDPWR_N pin toggled (power key pressed)
         */
         if ((Trim(boot_reason) == "3" || reboot_reason == "true")
                 && Trim(power_off_alarm) == "1") {
             property_set("ro.alarm_boot", "true");
         } else {
             property_set("ro.alarm_boot", "false");
         }
    }
}

void vendor_load_properties()
{
    std::string platform;
    std::string hw_device;

    char const *hw_id_file = "/sys/devices/platform/HardwareInfo/hw_id";

    hw_device = GetProperty("ro.board.variant", "");
    if (hw_device.compare("d9")) {
         property_set ( "ro.vendor.product.model", "MI PAD 4");
    } else if (hw_device.compare("d9p")) {
        property_set ( "ro.vendor.product.model", "MI PAD 4 PLUS");
    }

    ReadFileToString(hw_id_file, &hw_device);
    if (hw_device.find("D9P") != std::string::npos) {
        property_override_dual("ro.product.model", "ro.vendor.product.model", "MI PAD 4 PLUS");
    } else {
        property_override_dual("ro.product.model", "ro.vendor.product.model", "MI PAD 4");
    }

    init_alarm_boot_properties();
}

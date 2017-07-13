TARGET_USES_AOSP := true
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false

ifeq ($(TARGET_USES_AOSP),true)
TARGET_DISABLE_DASH := true
else
DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8996/overlay
endif

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

# Default vendor configuration.
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := true
endif

# Disable QTIC until it's brought up in split system/vendor
# configuration to avoid compilation breakage.
ifeq ($(ENABLE_VENDOR_IMAGE), true)
#TARGET_USES_QTIC := false
endif

BOARD_HAVE_QCOM_FM := true
TARGET_USES_NQ_NFC := false # bring-up hack
BOARD_FRP_PARTITION_NAME :=frp

TARGET_KERNEL_VERSION := 3.18

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/msm8996/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/msm8996/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# copy customized media_profiles and media_codecs xmls for msm8996
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += \
    device/qcom/msm8996/media_profiles.xml:system/etc/media_profiles.xml \
    device/qcom/msm8996/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
    device/qcom/msm8996/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/qcom/msm8996/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif  #TARGET_ENABLE_QC_AV_ENHANCEMENTS

PRODUCT_COPY_FILES += device/qcom/msm8996/whitelistedapps.xml:system/etc/whitelistedapps.xml \
                      device/qcom/msm8996/gamedwhitelist.xml:system/etc/gamedwhitelist.xml

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/qcom/common/common64.mk)

#msm8996 platform WLAN Chipset
WLAN_CHIPSET := qca_cld

PRODUCT_NAME := msm8996
PRODUCT_DEVICE := msm8996
PRODUCT_BRAND := Android
PRODUCT_MODEL := MSM8996 for arm64

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext

PRODUCT_PACKAGES += telephony-ext

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
#PRODUCT_BOOT_JARS += com.qti.dpmframework
#PRODUCT_BOOT_JARS += dpmapi
#PRODUCT_BOOT_JARS += com.qti.location.sdk
#Android oem shutdown hook
PRODUCT_BOOT_JARS += oem-services
endif

ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
endif #BOARD_HAVE_QCOM_FM

# add vendor manifest file
PRODUCT_COPY_FILES += \
    device/qcom/msm8996/vintf.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8996/msm8996.mk

# WLAN driver configuration files
PRODUCT_COPY_FILES += \
    device/qcom/msm8996/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf


#for wlan
PRODUCT_PACKAGES += \
    wificond \
    wifilogd
ifneq ($(WLAN_CHIPSET),)
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/qcom/msm8996/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:system/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:system/etc/permissions/android.hardware.sensor.hifi_sensors.xml

# Fingerprint feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml \

# dm-verity configuration
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system
ifeq ($(ENABLE_VENDOR_IMAGE), true)
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/bootdevice/by-name/vendor
endif

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml

# High performance VR feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:system/etc/permissions/android.hardware.vr.high_performance.xml

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8996/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

PRODUCT_PROPERTY_OVERRIDES += \
    camera.disable_zsl_mode=1

# List of AAPT configurations
PRODUCT_AAPT_CONFIG += xlarge large

# Powerhint configuration file
PRODUCT_COPY_FILES += \
device/qcom/msm8996/powerhint.xml:system/etc/powerhint.xml

#Healthd packages
PRODUCT_PACKAGES += android.hardware.health@1.0-impl \
                   android.hardware.health@1.0-convert \
                   android.hardware.health@1.0-service \
                   libhealthd.msm

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Add the overlay path
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
        $(PRODUCT_PACKAGE_OVERLAYS)

# Enable logdumpd service only for non-perf bootimage
ifeq ($(findstring perf,$(KERNEL_DEFCONFIG)),)
    ifeq ($(TARGET_BUILD_VARIANT),user)
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=0
    else
        #PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
            ro.logdumpd.enabled=1
    endif
else
    PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
        ro.logdumpd.enabled=0
endif

-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
        MULTI_LANG_ENGINE := REVERIE
endif

#Enable keymaster Impl HAL Compilation
PRODUCT_PACKAGES += android.hardware.keymaster@3.0-impl
#Enable Lights Impl HAL Compilation
PRODUCT_PACKAGES += android.hardware.light@2.0-impl
# Defined the locales
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN

# config.mk
#
# Product-specific compile-time definitions
#

TARGET_BOARD_PLATFORM := msm8996
# This value will be shown on fastboot menu
TARGET_BOOTLOADER_BOARD_NAME := QC_Reference_Phone

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
#TARGET_CPU_VARIANT := kryo
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
ifneq ($(TARGET_USES_AOSP), true)
TARGET_2ND_CPU_VARIANT := generic
else
TARGET_2ND_CPU_VARIANT := generic
endif

TARGET_NO_BOOTLOADER := false
TARGET_NO_KERNEL := false
BOOTLOADER_GCC_VERSION := arm-eabi-4.8
BOOTLOADER_PLATFORM := msm8996 # use msm8996 LK configuration

#TARGET_USES_OVERLAY := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096
QTI_S3D := true # Enable S3D GPU compostion

BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true

USE_CLANG_PLATFORM_BUILD := true

-include $(QCPATH)/common/msm8996/BoardConfigVendor.mk

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/qcom/common

USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

ifeq ($(ENABLE_VENDOR_IMAGE), true)
TARGET_RECOVERY_FSTAB := device/qcom/msm8996/recovery_vendor_variant.fstab
else
TARGET_RECOVERY_FSTAB := device/qcom/msm8996/recovery.fstab
endif

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

ifeq ($(ENABLE_VENDOR_IMAGE), true)
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
endif

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_QCOM_DISPLAY_BSP := true
TARGET_USES_COLOR_METADATA := true

ifneq ($(TARGET_USES_AOSP),true)
TARGET_USES_QCOM_BSP := true
endif

ifeq ($(BOARD_KERNEL_CMDLINE),)
ifeq ($(TARGET_KERNEL_VERSION),4.4)
    BOARD_KERNEL_CMDLINE += console=ttyMSM0,115200,n8 androidboot.console=ttyMSM0
else
    BOARD_KERNEL_CMDLINE += console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0
endif

BOARD_KERNEL_CMDLINE += androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff
endif

BOARD_SECCOMP_POLICY := device/qcom/$(TARGET_BOARD_PLATFORM)/seccomp

BOARD_EGL_CFG := device/qcom/$(TARGET_BOARD_PLATFORM)/egl.cfg

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x02000000
BOARD_RAMDISK_OFFSET     := 0x02200000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := false

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

TARGET_NO_RPC := true

TARGET_PLATFORM_DEVICE_BASE := /devices/soc/
TARGET_INIT_VENDOR_LIB := libinit_msm

#Enable Peripheral Manager
TARGET_PER_MGR_ENABLED := true

TARGET_HW_DISK_ENCRYPTION := true

TARGET_CRYPTFS_HW_PATH := device/qcom/common/cryptfs_hw

BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_BOOTIMG_SIGNED := true

DEX_PREOPT_DEFAULT := nostripping

# Enable dex pre-opt to speed up initial boot
ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
endif

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#Enable early mount support for mmc/ufs
EARLY_MOUNT_SUPPORT := true

# Enable build with MSM kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

TARGET_KERNEL_APPEND_DTB := true
# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := false

#Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES := true
#TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_msm
TARGET_RECOVERY_UI_LIB := librecovery_ui_msm

#Add support for firmare upgrade on 8996
HAVE_SYNAPTICS_DSX_FW_UPGRADE := true

BOARD_HAL_STATIC_LIBRARIES := libhealthd.msm

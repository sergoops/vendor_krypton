PATH_OVERRIDE_SOONG := $(shell echo $(TOOLS_PATH_OVERRIDE) | sed -e 's|$$|$$$$|g')

# Add variables that we wish to make available to soong here.
EXPORT_TO_SOONG := \
    KERNEL_ARCH \
    KERNEL_BUILD_OUT_PREFIX \
    KERNEL_CROSS_COMPILE \
    KERNEL_MAKE_CMD \
    KERNEL_MAKE_FLAGS \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_SOURCE

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += kryptonVarsPlugin
SOONG_CONFIG_kryptonVarsPlugin :=

SOONG_CONFIG_NAMESPACES += kryptonGlobalVars
SOONG_CONFIG_kryptonGlobalVars += \
    bootloader_message_offset \
    camera_skip_kind_check \
    target_surfaceflinger_udfps_lib \
    target_init_vendor_lib \
    camera_needs_client_info_defaults  \
    target_ld_shim_libs

SOONG_CONFIG_NAMESPACES += kryptonQcomVars
SOONG_CONFIG_kryptonQcomVars += \
    no_camera_smooth_apis \
    uses_qti_camera_device \
    should_wait_for_qsee \
    supports_hw_fde \
    supports_hw_fde_perf \
    supports_extended_compress_format \
    uses_pre_uplink_features_netmgrd

# Only create display_headers_namespace var if dealing with UM platforms to avoid breaking build for all other platforms
ifneq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_kryptonQcomVars += \
    qcom_display_headers_namespace
endif

define addVar
    SOONG_CONFIG_kryptonVarsPlugin += $(1)
    SOONG_CONFIG_kryptonVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

# Set default values
BOOTLOADER_MESSAGE_OFFSET ?= 0
TARGET_SURFACEFLINGER_UDFPS_LIB ?= surfaceflinger_udfps_lib
TARGET_INIT_VENDOR_LIB ?= vendor_init
TARGET_CAMERA_NEEDS_CLIENT_INFO ?= false

# Soong bool variables
SOONG_CONFIG_kryptonQcomVars_uses_pre_uplink_features_netmgrd := $(TARGET_USES_PRE_UPLINK_FEATURES_NETMGRD)

# Soong value variables
SOONG_CONFIG_kryptonGlobalVars_camera_skip_kind_check := $(CAMERA_SKIP_KIND_CHECK)
SOONG_CONFIG_kryptonGlobalVars_bootloader_message_offset := $(BOOTLOADER_MESSAGE_OFFSET)
SOONG_CONFIG_kryptonGlobalVars_target_surfaceflinger_udfps_lib := $(TARGET_SURFACEFLINGER_UDFPS_LIB)
SOONG_CONFIG_kryptonGlobalVars_target_ld_shim_libs := $(subst $(space),:,$(TARGET_LD_SHIM_LIBS))
SOONG_CONFIG_kryptonQcomVars_no_camera_smooth_apis := $(TARGET_HAS_NO_CAMERA_SMOOTH_APIS)
SOONG_CONFIG_kryptonQcomVars_uses_qti_camera_device := $(TARGET_USES_QTI_CAMERA_DEVICE)
SOONG_CONFIG_kryptonGlobalVars_target_init_vendor_lib := $(TARGET_INIT_VENDOR_LIB)
SOONG_CONFIG_kryptonGlobalVars_camera_needs_client_info_defaults := $(TARGET_CAMERA_NEEDS_CLIENT_INFO)
SOONG_CONFIG_kryptonQcomVars_should_wait_for_qsee := $(TARGET_KEYMASTER_WAIT_FOR_QSEE)
SOONG_CONFIG_kryptonQcomVars_supports_hw_fde := $(TARGET_HW_DISK_ENCRYPTION)
SOONG_CONFIG_kryptonQcomVars_supports_hw_fde_perf := $(TARGET_HW_DISK_ENCRYPTION_PERF)
SOONG_CONFIG_kryptonQcomVars_supports_extended_compress_format := $(AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT)

ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_kryptonQcomVars_qcom_display_headers_namespace := vendor/qcom/opensource/display-commonsys-intf
else
SOONG_CONFIG_kryptonQcomVars_qcom_display_headers_namespace := $(QCOM_SOONG_NAMESPACE)/display
endif

ifneq ($(TARGET_USE_QTI_BT_STACK),true)
PRODUCT_SOONG_NAMESPACES += packages/apps/Bluetooth
endif #TARGET_USE_QTI_BT_STACK

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

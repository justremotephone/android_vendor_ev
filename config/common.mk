PRODUCT_BRAND ?= evervolv

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Pyxis.ogg \
    ro.config.notification_sound=Merope.ogg \
    ro.config.alarm_alert=Scandium.ogg

# Make sure our default sounds make it in.
FW_SNDS_PATH := frameworks/base/data/sounds
PRODUCT_COPY_FILES += \
    $(FW_SNDS_PATH)/ringtones/ogg/Pyxis.ogg:system/media/audio/ringtones/Pyxis.ogg \
    $(FW_SNDS_PATH)/notifications/Merope.ogg:system/media/audio/notifications/Merope.ogg \
    $(FW_SNDS_PATH)/alarms/ogg/Scandium.ogg:system/media/audio/alarms/Scandium.ogg

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Required packages
PRODUCT_PACKAGES += \
    Launcher3 \
    EVToolbox \
    EVUpdater \
    EVTips \
    EVWidgets \
    EVWallpapers \
    su

# Backup Transport
PRODUCT_PACKAGE_OVERLAYS += $(SRC_EVERVOLV_DIR)/overlay/common

# Disable strict mode
ADDITIONAL_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=true

# SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Commandline / Init stuff
$(call inherit-product, $(SRC_EVERVOLV_DIR)/config/tools.mk)

# LatinIME english dictionary
$(call inherit-product, $(SRC_EVERVOLV_DIR)/config/dictionaries/english.mk)

# Hot reboot
PRODUCT_PACKAGE_OVERLAYS += vendor/ev/overlay/hot_reboot

#
# Version Info
#

PRODUCT_VERSION_MAJOR = 5
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0

# Allow overriding p1/2 etc from commandline
ifneq "" "$(DEVICE_VERSION_OVERRIDE)"
  PRODUCT_VERSION_EXTRA = $(DEVICE_VERSION_OVERRIDE)
else
  PRODUCT_VERSION_EXTRA = $(PRODUCT_VERSION_DEVICE_SPECIFIC)
endif

ifneq ($(APPEND_ZIP_VERSION),)
APPEND_ZIP=-$(APPEND_ZIP_VERSION)
endif

ifeq ($(NIGHTLY_BUILD),true)
  ROM_VERSION := $(TARGET_PRODUCT)-nightly-$(shell date +%Y.%m.%d)$(APPEND_ZIP)
else ifeq ($(TESTING_BUILD),true)
  ROM_VERSION := $(TARGET_PRODUCT)-testing-$(shell date +%Y.%m.%d)$(APPEND_ZIP)
else
  ROM_VERSION := $(TARGET_PRODUCT)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_EXTRA)-$(PRODUCT_CODENAME)$(APPEND_ZIP)
endif

ROM_VERSION := $(shell echo ${ROM_VERSION} | tr [:upper:] [:lower:])

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.romversion=$(ROM_VERSION)

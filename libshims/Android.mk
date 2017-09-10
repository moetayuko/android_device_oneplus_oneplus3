include $(CLEAR_VARS)

LOCAL_SRC_FILES := get_process_name.c

LOCAL_MODULE := libshims_get_process_name
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

#include <string>
#include <dlfcn.h>
#include <cstring>

__BEGIN_DECLS

int __android_log_is_debuggable() {
    return 1;
}

int property_get(const char* key, char* value, const char* default_value) {
    if (!strcmp("ro.debuggable", key)) {
        if (value) {
            strcpy(value, "1");
            return strlen(value);
        }
    }
    
    static auto real_property_get = reinterpret_cast<decltype(property_get)*>(
        dlsym(RTLD_NEXT, "property_get"));
    if (real_property_get) {
        return real_property_get(key, value, default_value);
    }
    return -1;
}

bool adbd_auth_verify(const char* token, size_t token_size,
                      const char* sig, int sig_len) {
    return true;
}

__END_DECLS
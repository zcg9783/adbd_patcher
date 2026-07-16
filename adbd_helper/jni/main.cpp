#include <unistd.h>
#include <stdlib.h>

#ifdef __LP64__
#define HELPER_LIB "/system/lib64/libadb_root_helper.so"
#else
#define HELPER_LIB "/system/lib/libadb_root_helper.so"
#endif

int main(int argc, char** argv) {
    const char* real_adbd = "/apex/com.android.adbd/bin/adbd.real";
    if (access(real_adbd, F_OK) != 0) {
        real_adbd = "/system/bin/adbd.real";
    }

    setenv("LD_PRELOAD", HELPER_LIB, 1);

    char* const new_argv[] = {
        argv[0],
        const_cast<char*>("--root_seclabel=u:r:magisk:s0"),
        nullptr
    };

    return execv(real_adbd, new_argv);
}
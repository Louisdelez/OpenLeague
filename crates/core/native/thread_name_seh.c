/* The small Windows SEH boundary needed by native8A92A0. Rust owns the name
 * and engine lifecycle. Windows pointer width determines the debugger payload.
 * Protocol: https://learn.microsoft.com/en-us/visualstudio/debugger/tips-for-debugging-threads */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#pragma pack(push, 8)
struct ol_debug_name {
    DWORD kind;
    const char *text;
    DWORD thread;
    DWORD flags;
};
#pragma pack(pop)

void ol_engine_debug_name(const char *text) {
    struct ol_debug_name payload = {0};
    payload.kind = 0x1000;
    payload.text = text;
    payload.thread = 0xffffffff;
    __try {
        RaiseException(0x406d1388, 0, sizeof(payload) / sizeof(ULONG_PTR),
                       (const ULONG_PTR *)&payload);
    } __except (EXCEPTION_EXECUTE_HANDLER) {
        /* Native8A9307 selects the handler;8A930D resumes the wrapper. */
    }
}

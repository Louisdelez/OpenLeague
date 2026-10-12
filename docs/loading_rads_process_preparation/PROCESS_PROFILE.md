# Explicit resource-loading process profile

This preparation composes the original EXE and RiotRadsIO.dll x86 instructions
inside the same Unicorn machine. It does not launch a normal match, execute
the x86 DLL in Python64, or import Python arguments/environment into the guest.

The executable identity is the virtual path `bridge.cwd/League of Legends.exe`,
whose resolver maps to the pinned source EXE. Its quoted ASCII spelling, with
no other argument and one trailing NUL, owns a read-only guest page from
`0x3B000000`. Repeated GetCommandLineA returns that same borrowed pointer. The
page survives native attach and deferred native cleanup callbacks; terminal
process-profile retirement occurs afterwards, independently of native CRT free.
The native DLL stores this pointer at `0x10199AB8` before its real argv parser.

GetEnvironmentStringsW is an explicitly declared guest-process input, not an
observation of the host environment. Each call allocates a distinct read-only
guest page containing the requested UTF16LE block and double NUL. The supported
profiles are empty and the three public test variables `OL_PROFILE=resource_probe`,
`OL_VALUE=café`, `OL_EMPTY=`. Matching FreeEnvironmentStringsW retires only a
currently owned environment block. Command-line, interior, unknown and stale
pointers are rejected. The whole reserved range must fit in32bits.

The genuine converter `0x100FF7AE` performs its own scan, size query, allocation,
WideCharToMultiByte call and input release. Empty input converts one WCHAR into
one zero byte by the native scan. The controlled block converted into51 bytes
on this host's ACP1252 in the executed intermediate probe. No output string is
written as a replacement for the native converter or its later table builder.

New NLS adapters delegate to actual Windows functions using separately owned
and bounded host buffers. GetCPInfo transfers its20-byte structure including
the unchanged padding. GetStringTypeW transfers one WORD per explicit WCHAR.
The qualified LCMapStringEx adapter restricts support to lower/uppercase mapping,
positive explicit counts, zero optional fields and nonoverlapping buffers.
Capacity0 never inspects the ignored output pointer. Full output is transferred
even after OS failure because partial output is permitted by that API.

The separately tested synchronization adapter permits only unnamed, noninherited
semaphores/events. It reserves a registry slot before acquisition and adopts
the actual handle before logging or returning to native code. This ownership
is independent of the native4-byte wrapper allocation. CloseHandle(0) calls the
real API and preserves its failure. A tracked owner is removed only on a
successful close. Unknown waits, signals, threads and ETW remain explicit stops.

Both final native profiles use identical generator hashes and stop at HeapReAlloc
while growing the atexit table from128 to256 bytes. They returned from lowIO,
argv and environment-table construction, then five C and45 C++ initializers;
the46th C++ initializer is interrupted. The original process command-line page
remains borrowed, argc is1, and the declared environment table has zero/three
entries. Synchronization creation is tested separately and has not been reached
by either final provider composition. Historical captures preserve earlier
source revisions and frontiers and are not qualifications of the final code.

HeapSize resolves only exact owned host allocation bases and refuses to expose
a size larger than the guest mirror capacity. GetCurrentThread returns the real
borrowed pseudo-handle translated to32bits; GetThreadTimes uses one bounded host
span so overlapping native FILETIME outputs remain overlapping. SSE2 query10
returns the real OS value; no CPU capability flag is forced in the guest.

InitializeSListHead is not called through its incompatible host64 structure ABI.
The pinned current Windows SysWOW64 kernel32 export forwards to a19-byte leaf
in SysWOW64/ntdll. Those exact x86 bytes execute in Unicorn, performing the two
DWORD read/modify/writes and ret4. Its13 checks are real x86 leaf executions,
separate from the287 remaining static/adapter checks. It is not a general ntdll
loader or a reconstruction of the operating system used in2014.

OS contracts consulted:

- https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinea
- https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getenvironmentstringsw
- https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-freeenvironmentstringsw
- https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getacp
- https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-isvalidcodepage
- https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getcpinfo
- https://learn.microsoft.com/en-us/windows/win32/api/winnls/ns-winnls-cpinfo
- https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-getstringtypew
- https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-lcmapstringex
- https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-createsemaphorea
- https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-createeventa
- https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-closehandle
- https://learn.microsoft.com/en-us/windows/win32/api/heapapi/nf-heapapi-heapsize
- https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getcurrentthread
- https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-getthreadtimes
- https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-isprocessorfeaturepresent
- https://learn.microsoft.com/en-us/windows/win32/api/interlockedapi/nf-interlockedapi-initializeslisthead

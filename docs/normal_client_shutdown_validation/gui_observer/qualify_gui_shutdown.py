"""Opt-in real normal-client window-close qualification. Never imported to launch.

No diagnostic CLI, compiler, server startup, injected failure, kill or broadcast.
A timeout leaves the exact launched process running and reports its PID explicitly.
"""
from __future__ import annotations
import argparse
import ctypes as C
from ctypes import wintypes as W
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
from datetime import datetime, timezone

TITLE = "OpenLeague - developpement 4.20"
SCOPE_SECTION = 0x2D6ED58
PREFIXES = ("NATIVE_RUNTIME_SHUTDOWN ", "NATIVE_RUNTIME_AFTER_RUN ")


def digest(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def parse_reports(text):
    found = {prefix.strip(): [] for prefix in PREFIXES}
    for line in text.splitlines():
        for prefix in PREFIXES:
            if line.startswith(prefix):
                value = json.loads(line[len(prefix):])
                if not isinstance(value, dict):
                    raise ValueError("shutdown report is not an object")
                found[prefix.strip()].append(value)
    return found


def validate_reports(found):
    """Strict checks of actual diagnostics; no synthetic report is emitted."""
    errors = []
    def eq(value, wanted, label):
        if type(value) is not type(wanted) or value != wanted:
            errors.append(label)
    def integer(value, label, minimum=0):
        if type(value) is not int or value < minimum:
            errors.append(label)
            return False
        return True
    for prefix in PREFIXES:
        if len(found.get(prefix.strip(), [])) != 1:
            errors.append("expected exactly one " + prefix.strip())
    if errors:
        return errors
    checkpoint = found[PREFIXES[0].strip()][0]
    after = found[PREFIXES[1].strip()][0]
    eq(checkpoint.get("checkpoint"), "native-runtime-app-exit", "checkpoint identity")
    eq(checkpoint.get("passed"), True, "checkpoint failed")
    eq(checkpoint.get("complete"), False, "checkpoint completion claim")
    eq(checkpoint.get("errors"), [], "checkpoint errors")
    eq(checkpoint.get("phase_order"), ["service", "runtime", "application"], "close order")
    eq(checkpoint.get("producer_sample_requested_during_shutdown"), False, "shutdown requested producer")
    runtime = checkpoint.get("runtime")
    app = checkpoint.get("application")
    clock = checkpoint.get("clock")
    if not all(isinstance(value, dict) for value in (runtime, app, clock)):
        return errors + ["missing runtime/Application/clock diagnostics"]
    for name in ("engine_allocations", "active_workers", "handles"):
        eq(runtime.get(name), 0, "runtime " + name)
    # One Shared-scope section remains while EffectClock and Service are retained
    # for the checkpoint. The identified scope owner must later drop, not be
    # mislabeled as a leak or forced to zero before Shared::drop.
    eq(runtime.get("critical_sections"), 1, "checkpoint Shared-scope section count")
    eq(runtime.get("scope_critical_section_reference"), SCOPE_SECTION, "scope section identity")
    eq(runtime.get("critical_section_failures"), [], "runtime section failures")
    eq(runtime.get("errors"), [], "runtime errors")
    eq(app.get("closed"), True, "Application not closed")
    eq(app.get("transport", "missing"), None, "Application retains transport")
    for name in ("workers_created", "workers_closed", "worker_completions"):
        integer(app.get(name), "Application " + name)
    eq(app.get("workers_created"), app.get("workers_closed"), "workers not closed")
    eq(app.get("workers_created"), app.get("worker_completions"), "workers not completed")
    eq(app.get("worker_failures"), [], "worker failures")
    eq(app.get("handle_failures"), 0, "Application handle failures")
    crt = app.get("crt")
    if not isinstance(crt, dict):
        errors.append("missing Application CRT diagnostics")
    else:
        for name in ("heap_blocks", "retained_mirrors", "critical_sections", "heap_failures", "lock_failures"):
            eq(crt.get(name), 0, "CRT " + name)
        for name in ("heap_allocations", "heap_frees"):
            integer(crt.get(name), "CRT " + name)
        eq(crt.get("heap_allocations"), crt.get("heap_frees"), "CRT allocation/free mismatch")
    eq(clock.get("initialized"), True, "normal frame did not initialize the clock")
    integer(clock.get("origin"), "clock origin")
    integer(clock.get("frequency"), "clock frequency", 1)
    eq(clock.get("qpf_calls"), 1, "clock QPF call count")
    integer(clock.get("qpc_calls"), "insufficient clock activity before close", 4)
    for name in ("crt_allocations", "pending_mirrors", "inner_mutexes", "event_close_failures"):
        eq(clock.get(name), 0, "clock " + name)
    eq(clock.get("registered_cleanups"), [], "clock cleanup registrations")
    eq(clock.get("failure", "missing"), None, "clock failure")
    for name in ("events_created", "events_closed"):
        integer(clock.get(name), "clock " + name)
    eq(clock.get("events_created"), clock.get("events_closed"), "clock events not closed")
    eq(after.get("checkpoint_observed"), True, "post-run checkpoint absent")
    eq(after.get("checkpoint"), checkpoint, "post-run checkpoint changed")
    eq(after.get("report_error", "missing"), None, "post-run report error")
    eq(after.get("critical_section_failures"), [], "late section deletion failures")
    eq(after.get("critical_section_report_owners"), 1, "Shared/report owner retained after runner")
    eq(after.get("direct_os_deletion_count_observed"), False, "unsupported direct OS count claim")
    eq(after.get("cleanup_failed"), False, "post-run cleanup failed")
    eq(after.get("complete"), False, "post-run completion claim")
    return errors


class Win32:
    def __init__(self):
        self.user = C.WinDLL("user32", use_last_error=True)
        self.kernel = C.WinDLL("kernel32", use_last_error=True)
        self.callback = C.WINFUNCTYPE(W.BOOL, W.HWND, W.LPARAM)
        signatures = [
            (self.user, "EnumWindows", [self.callback, W.LPARAM], W.BOOL),
            (self.user, "IsWindow", [W.HWND], W.BOOL),
            (self.user, "IsWindowVisible", [W.HWND], W.BOOL),
            (self.user, "GetWindowThreadProcessId", [W.HWND, C.POINTER(W.DWORD)], W.DWORD),
            (self.user, "GetWindowTextW", [W.HWND, W.LPWSTR, C.c_int], C.c_int),
            (self.user, "GetClassNameW", [W.HWND, W.LPWSTR, C.c_int], C.c_int),
            (self.user, "GetWindowRect", [W.HWND, C.POINTER(W.RECT)], W.BOOL),
            (self.user, "WaitForInputIdle", [W.HANDLE, W.DWORD], W.DWORD),
            (self.user, "SendMessageTimeoutW", [W.HWND, W.UINT, W.WPARAM, W.LPARAM,
                                             W.UINT, W.UINT, C.POINTER(C.c_size_t)], C.c_ssize_t),
            (self.user, "PostMessageW", [W.HWND, W.UINT, W.WPARAM, W.LPARAM], W.BOOL),
            (self.kernel, "OpenProcess", [W.DWORD, W.BOOL, W.DWORD], W.HANDLE),
            (self.kernel, "CloseHandle", [W.HANDLE], W.BOOL),
            (self.kernel, "QueryFullProcessImageNameW", [W.HANDLE, W.DWORD, W.LPWSTR, C.POINTER(W.DWORD)], W.BOOL),
        ]
        for library, name, args, result in signatures:
            fn = getattr(library, name)
            fn.argtypes, fn.restype = args, result

    def image(self, handle):
        size = W.DWORD(32768)
        value = C.create_unicode_buffer(size.value)
        if not self.kernel.QueryFullProcessImageNameW(handle, 0, value, C.byref(size)):
            raise C.WinError(C.get_last_error())
        return Path(value.value).resolve()

    def window(self, hwnd, pid):
        owner = W.DWORD()
        tid = self.user.GetWindowThreadProcessId(hwnd, C.byref(owner))
        if owner.value != pid or not tid or not self.user.IsWindow(hwnd) or not self.user.IsWindowVisible(hwnd):
            return None
        title, kind, rect = C.create_unicode_buffer(2048), C.create_unicode_buffer(256), W.RECT()
        self.user.GetWindowTextW(hwnd, title, len(title))
        self.user.GetClassNameW(hwnd, kind, len(kind))
        if not self.user.GetWindowRect(hwnd, C.byref(rect)):
            raise C.WinError(C.get_last_error())
        return dict(hwnd=int(hwnd), pid=owner.value, thread_id=tid, title=title.value,
                    window_class=kind.value, rect=[rect.left, rect.top, rect.right, rect.bottom])

    def windows(self, pid):
        windows, errors = [], []
        @self.callback
        def visit(hwnd, _):
            try:
                window = self.window(hwnd, pid)
                if window:
                    windows.append(window)
                return True
            except Exception as error:
                errors.append(error)
                return False
        if not self.user.EnumWindows(visit, 0) and not errors:
            raise C.WinError(C.get_last_error())
        if errors:
            raise errors[0]
        return windows

    def responsive(self, hwnd):
        result = C.c_size_t()
        C.set_last_error(0)
        ok = bool(self.user.SendMessageTimeoutW(hwnd, 0, 0, 0, 0x0001 | 0x0002, 200, C.byref(result)))
        return dict(ok=ok, last_error=C.get_last_error(), wm_null_result=result.value)


def run(args):
    if os.name != "nt" or not args.run:
        raise ValueError("Windows and explicit --run are required; this is not a dry-run launcher")
    exe, root, output = Path(args.exe).resolve(), Path(args.project_root).resolve(), Path(args.output_dir).resolve()
    if not re.fullmatch(r"[0-9a-fA-F]{64}", args.exe_sha256):
        raise ValueError("--exe-sha256 must be the fresh build SHA256")
    if exe != root / "target" / "debug" / "openleague-client.exe":
        raise ValueError("expected the normal client's project target/debug executable")
    if digest(exe) != args.exe_sha256.lower():
        raise ValueError("executable SHA256 does not match the supplied build")
    if not output.is_relative_to(Path(r"E:\mapslol3v3").resolve()) or output == Path(r"E:\mapslol3v3").resolve():
        raise ValueError("observation output must be a new directory beneath E:\\mapslol3v3")
    if output.exists():
        raise ValueError("observation output already exists; preserve prior evidence")
    if not (1 <= args.startup_seconds <= 180 and 1 <= args.exit_seconds <= 60 and 1 <= args.settle_seconds <= 30):
        raise ValueError("deadlines out of range: startup 1..180, exit 1..60, settle 1..30 seconds")
    # Environment-enabled diagnostics can change the normal path or write probe
    # files. Do not silently sanitize them or accept an altered profile.
    inherited = sorted(key for key in os.environ if key.upper().startswith("OPENLEAGUE_"))
    if inherited:
        raise ValueError("normal-profile qualification requires unset OPENLEAGUE_* variables: " + ", ".join(inherited))
    output.mkdir(parents=True, exist_ok=False)
    started = time.monotonic()
    report = dict(schema=1, passed=False, complete=False, profile="normal client, no CLI arguments",
                  started_utc=datetime.now(timezone.utc).isoformat(), executable=str(exe),
                  executable_sha256=args.exe_sha256.lower(), cwd=str(root),
                  deadlines=dict(startup_seconds=args.startup_seconds, exit_seconds=args.exit_seconds,
                                 settle_seconds=args.settle_seconds), timeline=[], errors=[],
                  process_launched=False, wm_close_posted=False, forced_termination=False,
                  limits=["Visible HWND and WM_NULL response do not prove framebuffer or gameplay fidelity.",
                          "Native cleanup evidence is the client diagnostic contract, not direct OS deletion instrumentation.",
                          "One normal WM_CLOSE run does not qualify injected OS failure or all event-loop exits.",
                          "Timeouts retain the launched process; no kill, broadcast or other process is targeted."])
    def event(name, **values):
        report["timeline"].append(dict(event=name, elapsed_seconds=round(time.monotonic() - started, 3), **values))
    def save():
        path = output / "qualification.json"
        pending = output / "qualification.pending.json"
        pending.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        pending.replace(path)
    proc = handle = api = None
    stdout_path, stderr_path = output / "stdout.log", output / "stderr.log"
    interrupted = False
    try:
        api = Win32()
        save()
        with stdout_path.open("xb") as stdout, stderr_path.open("xb") as stderr:
            # Direct executable invocation, no shell and no hidden GUI window.
            proc = subprocess.Popen([str(exe)], cwd=root, stdin=subprocess.DEVNULL,
                                    stdout=stdout, stderr=stderr, shell=False)
            report.update(process_launched=True, pid=proc.pid)
            event("launched", pid=proc.pid)
            save()
            handle = api.kernel.OpenProcess(0x00100000 | 0x1000, False, proc.pid)
            if not handle:
                raise C.WinError(C.get_last_error())
            if api.image(handle) != exe:
                raise ValueError("launched process image does not match the requested executable")
            event("process_image_verified")
            startup_end = time.monotonic() + args.startup_seconds
            stable_since, stable_hwnd, target = None, None, None
            last_idle = None
            while time.monotonic() < startup_end:
                if proc.poll() is not None:
                    raise RuntimeError("normal client exited before targeted WM_CLOSE")
                candidates = api.windows(proc.pid)
                report["last_visible_windows"] = candidates
                matches = [value for value in candidates if value["title"] == TITLE]
                last_idle = int(api.user.WaitForInputIdle(handle, 100))
                if len(matches) == 1 and last_idle == 0:
                    candidate = matches[0]
                    response = api.responsive(candidate["hwnd"])
                    if response["ok"]:
                        if stable_hwnd != candidate["hwnd"]:
                            stable_hwnd, stable_since = candidate["hwnd"], time.monotonic()
                            event("visible_responsive_window", window=candidate, wm_null=response,
                                  wait_for_input_idle=last_idle)
                            save()
                        if time.monotonic() - stable_since >= args.settle_seconds:
                            target = candidate
                            break
                    else:
                        stable_hwnd, stable_since = None, None
                else:
                    stable_hwnd, stable_since = None, None
                time.sleep(0.1)
            report["last_wait_for_input_idle"] = last_idle
            if target is None:
                raise TimeoutError("no unique visible responsive normal-client window within startup deadline")
            # Recheck both process and HWND ownership immediately before the one
            # WM_CLOSE. Keep the process handle open to identify this lifetime.
            if proc.poll() is not None or api.image(handle) != exe:
                raise RuntimeError("process lifetime ended before close")
            current = api.window(target["hwnd"], proc.pid)
            response = api.responsive(target["hwnd"]) if current else {"ok": False}
            if not current or current["title"] != TITLE or not response["ok"]:
                raise RuntimeError("window identity or message pump changed before close")
            if not api.user.PostMessageW(target["hwnd"], 0x0010, 0, 0):
                raise C.WinError(C.get_last_error())
            report.update(wm_close_posted=True, target_window=current)
            event("wm_close_posted", window=current, wm_null=response)
            save()
            try:
                proc.wait(timeout=args.exit_seconds)
            except subprocess.TimeoutExpired:
                raise TimeoutError("normal client did not exit within WM_CLOSE deadline") from None
            event("process_exited", exit_code=proc.returncode)
    except BaseException as error:
        interrupted = isinstance(error, KeyboardInterrupt)
        report["errors"].append(f"{type(error).__name__}: {error}")
    finally:
        if handle and api and not api.kernel.CloseHandle(handle):
            report["errors"].append("observer process handle CloseHandle failed: " + str(C.get_last_error()))
        code = proc.poll() if proc else None
        report.update(exit_code=code, process_still_running=bool(proc and code is None),
                      finished_utc=datetime.now(timezone.utc).isoformat(),
                      elapsed_seconds=round(time.monotonic() - started, 3))
        report["logs"] = {name: dict(path=str(path), bytes=path.stat().st_size, sha256=digest(path),
                                      final=not report["process_still_running"])
                          for name, path in (("stdout", stdout_path), ("stderr", stderr_path)) if path.exists()}
        try:
            report["executable_sha256_after"] = digest(exe)
            if report["executable_sha256_after"] != report["executable_sha256"]:
                report["errors"].append("executable changed during observation")
            text = stderr_path.read_text(encoding="utf-8", errors="replace") if stderr_path.exists() else ""
            found = parse_reports(text)
            report["native_reports"] = found
            report["errors"].extend(validate_reports(found))
            for failure in ("Native effect clock stopped:", "Canonical process clock failed:"):
                if failure in text:
                    report["errors"].append("clock producer failure in stderr: " + failure)
        except Exception as error:
            report["errors"].append("diagnostic parsing failed: " + str(error))
        if code != 0:
            report["errors"].append("normal client did not return exit code 0")
        if not report["wm_close_posted"]:
            report["errors"].append("targeted WM_CLOSE was not posted")
        report["passed"] = not report["errors"]
        save()
    print(json.dumps({key: report[key] for key in ("passed", "complete", "exit_code", "process_still_running", "errors")}, ensure_ascii=False))
    print(str(output / "qualification.json"))
    return 130 if interrupted else (0 if report["passed"] else 1)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", action="store_true", help="explicitly launch the normal client and target its window")
    parser.add_argument("--exe", required=True)
    parser.add_argument("--exe-sha256", required=True, help="SHA256 of the freshly built executable; no inferred current build")
    parser.add_argument("--project-root", default=r"E:\OpenLeague")
    parser.add_argument("--output-dir", required=True, help="new observation directory under E:\\mapslol3v3")
    parser.add_argument("--startup-seconds", type=float, default=90)
    parser.add_argument("--settle-seconds", type=float, default=5)
    parser.add_argument("--exit-seconds", type=float, default=30)
    try:
        return run(parser.parse_args())
    except Exception as error:
        print(f"Preflight failed: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())

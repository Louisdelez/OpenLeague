"""Verify byte provenance and freeze the native-only oracle evidence."""
from pathlib import Path
import datetime
import hashlib
import json
import platform
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, "E:/OpenLeague/tools/pythonlibs")
import pefile
import unicorn

def sha(data):
    return hashlib.sha256(data).hexdigest()

proof = json.loads((ROOT / "native_lifecycle_oracle.json").read_text(encoding="utf-8"))
summary = json.loads((ROOT / "summary.json").read_text(encoding="utf-8"))
assert proof["passed"] and not proof["complete"] and summary["passed"]
counts = {key: len(proof[key]) for key in ("stop_cases", "outer_dynamic_cases", "outer_real_destructor_cases", "loading_pair_reset_cases")}
assert counts == {"stop_cases": 18, "outer_dynamic_cases": 14, "outer_real_destructor_cases": 4, "loading_pair_reset_cases": 16}
assert all(summary[k] == n for k, n in counts.items())
assert summary["proof_sha256"] == sha((ROOT / "native_lifecycle_oracle.json").read_bytes())
source = Path(r"D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe")
raw = source.read_bytes()
assert sha(raw) == proof["native_sha256"]
image = pefile.PE(data=raw).get_memory_mapped_image()
for region in proof["source_regions"]:
    data = (ROOT / region["path"]).read_bytes()
    start = region["address"] - 0x400000
    assert data == image[start:start+region["size"]]
    assert sha(data) == region["sha256"]
for instruction in proof["native_executed_instructions"]:
    start = instruction["address"] - 0x400000
    assert bytes.fromhex(instruction["bytes"]) == image[start:start+instruction["size"]]
assert summary["native_instruction_count"] == len(proof["native_executed_instructions"]) == 955
for dependency in proof["dependencies"]:
    assert sha(Path(dependency["path"]).read_bytes()) == dependency["sha256"]
files = []
for path in sorted(ROOT.rglob("*")):
    if path.is_file() and path.name != "qualification_manifest.json":
        data = path.read_bytes()
        files.append(dict(path=path.relative_to(ROOT).as_posix(), bytes=len(data), sha256=sha(data)))
manifest = dict(schema="openleague.native-service-lifecycle-oracle.v1", recorded_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), scope="Native x86 Stop72A9F0, shutdown fragment590F03..590F31 and loading pair reset577DF0", passed=True, complete_game=False, rust_port_present=False, rust_compiled=False, production_modified=False, source=str(source), source_sha256=sha(raw), counts=counts, total_cases=sum(counts.values()), native_instruction_addresses_checked=955, source_regions_checked=len(proof["source_regions"]), dependencies=proof["dependencies"], environment=dict(python=platform.python_version(), unicorn=unicorn.__version__, pefile=pefile.__version__), files=files, limits=proof["limits"])
path = ROOT / "qualification_manifest.json"
path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
print(json.dumps(dict(passed=True, total_cases=sum(counts.values()), files=len(files), manifest_sha256=sha(path.read_bytes()), proof_sha256=summary["proof_sha256"]), indent=2))

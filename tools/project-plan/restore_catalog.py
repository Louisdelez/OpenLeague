"""Restore the exact compressed task catalog shipped with the Git snapshot."""
from pathlib import Path
import gzip
import hashlib

ROOT = Path(__file__).resolve().parents[2]
TARGET = ROOT / "docs/completion_tasks_2026-10-20.json"
PACKED = TARGET.with_suffix(TARGET.suffix + ".gz")
EXPECTED_BYTES = 122544238
EXPECTED_SHA256 = "5d8beb474f4e8b8c9ff61f2fcc1216e5482b87b2f9cfc9004f7560cabd75d675"
PACKED_SHA256 = "1ea2c9781f44e225c50e3bf25716f26dc0d11d1baa739b0aaec39d4c1e9f8a46"

def digest(path):
    result = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            result.update(chunk)
    return result.hexdigest()

def main():
    if TARGET.exists():
        if TARGET.stat().st_size != EXPECTED_BYTES or digest(TARGET) != EXPECTED_SHA256:
            raise ValueError("Existing task catalog differs; preserve it and inspect the changes.")
        print("Exact task catalog already present.")
        return
    if digest(PACKED) != PACKED_SHA256:
        raise ValueError("Compressed task catalog differs from this snapshot.")
    total = 0
    result = hashlib.sha256()
    with gzip.open(PACKED, "rb") as source, TARGET.open("xb") as destination:
        while chunk := source.read(1024 * 1024):
            total += len(chunk)
            if total > EXPECTED_BYTES:
                raise ValueError("Task catalog exceeds its declared size; inspect the partial output.")
            result.update(chunk)
            destination.write(chunk)
    if total != EXPECTED_BYTES or result.hexdigest() != EXPECTED_SHA256:
        raise ValueError("Restored task catalog differs; inspect the partial output.")
    print("Restored and SHA-256 verified: " + str(TARGET))

if __name__ == "__main__":
    main()

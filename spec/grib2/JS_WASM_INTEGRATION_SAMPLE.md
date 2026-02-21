# GRIB2 JS/WASM Integration Sample

This sample shows how to use the I/O adapter APIs without binding the core parser to host-specific I/O.

## 1. Adapter Contract

- `parse_with_io(read_bytes, source)`
- `render_inventory_lines_with_io(read_bytes, source, mode)`
- `write_with_io(write_bytes, destination, context, strict=true)`

`read_bytes`/`write_bytes` are callbacks.  
Core GRIB2 logic never imports host I/O directly.

## 2. Node.js-style Adapter (example)

```text
read_bytes(path):
  bytes = host_fs_read(path)
  return Ok(bytes)

write_bytes(path, bytes):
  host_fs_write(path, bytes)
  return Ok(())

context = parse_with_io(read_bytes, "fixtures/sample.grib2")
lines = render_inventory_lines(context, InventoryShort)
write_with_io(write_bytes, "out.grib2", context, strict=true)
```

## 3. Browser/WASM-style Adapter (example)

```text
read_bytes(url):
  arr = fetch(url).arrayBuffer()
  return Ok(bytes_from_uint8array(arr))

lines = render_inventory_lines_with_io(read_bytes, "/data/gfs.grib2", InventorySec0)
```

In browser use-cases, writing can target:

- IndexedDB / OPFS
- in-memory buffer download
- postMessage transfer to worker/main thread

## 4. Verification Loop

- Compare `InventoryShort`, `InventorySec0`, `InventorySec3`, `InventorySec4`, `InventoryVarLev`
  outputs with committed snapshots.
- Keep CI free of `wgrib2` runtime dependency.

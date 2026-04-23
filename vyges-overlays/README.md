# Vyges overlays — opentitan-prim-generic

Same-name overrides that mask upstream files at vendor time.
Declared in `vyges-metadata.json → vyges_overlays[]`.

Upstream-sync policy: pulls proceed normally; any upstream change
to a path listed under `vyges_overlays[].replaces` is flagged for
human review.

## Files

| File | Replaces | Reason |
|---|---|---|
| `prim_flash.sv` | `rtl/prim_flash.sv` | Upstream `prim_flash.sv` depends on `flash_phy_pkg`/`ast_pkg` which are OpenTitan flash-controller infrastructure we don't pull. Replaced with a 3-line empty module so any transitive `prim_flash` instantiation elaborates to a no-op in non-flash SoCs. |
| `prim_generic_flash_bank.sv` | `rtl/prim_generic_flash_bank.sv` | Same class — upstream requires `flash_ctrl_top_specific_pkg` which isn't on our vendor path. Replaced with a bare module stub. |

// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Vyges overlay — Xilinx-aware clock gating cell.
//
// Replaces the upstream `always_latch` implementation, which infers a
// latch on Vivado synthesis (Synth 8-327). Under the synth warning gate
// (synth_warning_gate.tcl) Synth 8-327 is promoted to ERROR, so the
// upstream file would fail the build. Under `XILINX_FPGA` (set by
// build_<board>.tcl) we instantiate the BUFGCE primitive — no inferred
// latch. All other targets (Yosys ASIC, simulation) fall through to the
// upstream behavioural latch unchanged.

module prim_clock_gating #(
  parameter bit NoFpgaGate    = 1'b0,
  parameter bit FpgaBufGlobal = 1'b1
) (
  input        clk_i,
  input        en_i,
  input        test_en_i,
  output logic clk_o
);

`ifdef XILINX_FPGA
  if (NoFpgaGate) begin : gen_no_fpga_gate
    assign clk_o = clk_i;
  end else if (FpgaBufGlobal) begin : gen_fpga_buf_global
    BUFGCE u_bufgce (
      .I  (clk_i),
      .CE (en_i | test_en_i),
      .O  (clk_o)
    );
  end else begin : gen_fpga_buf_local
    BUFHCE u_bufhce (
      .I  (clk_i),
      .CE (en_i | test_en_i),
      .O  (clk_o)
    );
  end
`else
  logic en_latch /* verilator clock_enable */;
  always_latch begin
    if (!clk_i) begin
      en_latch = en_i | test_en_i;
    end
  end
  assign clk_o = en_latch & clk_i;
`endif

endmodule

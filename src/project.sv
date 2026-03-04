/*
 * Copyright (c) 2026 Alex Hegedus-Adkin
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_alex_ha_192 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  typedef enum {
    IDLE,
    S1,
    S2,
    S3,
    S4,
    S5,
    S6,
    S7,
    S8,
    S9,
    S10,
    S11
  } fsm_state_e;
  fsm_state_e current_state, next_state;

  always @(posedge clk) begin
    if (!rst_n) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  always_comb begin
    case (current_state)
      IDLE: next_state = S1;
      S1: next_state = S2;
      S2: next_state = S3;
      S3: next_state = S4;
      S4: next_state = S5;
      S5: next_state = S6;
      S6: next_state = S7;
      S7: next_state = S8;
      S8: next_state = S9;
      S9: next_state = S10;
      S10: next_state = S11;
      S11: next_state = S1;
      default: next_state = IDLE;
    endcase
  end

  // All output pins must be assigned. If not used, assign to 0.
  logic [7:0] uo_out_intermediate;

  always_comb begin
    case (current_state)
      IDLE: uo_out_intermediate = 8'h00;
      S1:   uo_out_intermediate = 8'h61;
      S2:   uo_out_intermediate = 8'h6C;
      S3:   uo_out_intermediate = 8'h65;
      S4:   uo_out_intermediate = 8'h78;
      S5:   uo_out_intermediate = 8'h2D;
      S6:   uo_out_intermediate = 8'h68;
      S7:   uo_out_intermediate = 8'h61;
      S8:   uo_out_intermediate = 8'h2E;
      S9:   uo_out_intermediate = 8'h63;
      S10:  uo_out_intermediate = 8'h6F;
      S11:  uo_out_intermediate = 8'h6D;
      default: uo_out_intermediate = 8'h00;
    endcase
  end

  assign uo_out = uo_out_intermediate;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule




module trafficLight(
  input clk,
  input rst,
  output reg [7:0] signal
);
  
  parameter R = 2'b00;
  parameter Y = 2'b01;
  parameter G = 2'b10;
  
  parameter FREQ = 100000;
  
  parameter RST = {Y,Y,Y,Y}; //YYYY 01010101 - 85
  parameter S0 = {G,R,R,R};  //GRRR	10000000 - 128
  parameter S1 = {Y,Y,R,R};  //YYRR	01010000 - 80
  parameter S2 = {R,G,R,R};  //RGRR	00100000 - 32
  parameter S3 = {R,Y,Y,R};  //RYYR	00010100 - 20
  parameter S4 = {R,R,G,R};  //RRGR	00001000 - 8
  parameter S5 = {R,R,Y,Y};  //RRYY	00000101 - 5
  parameter S6 = {R,R,R,G};  //RRRG	00000010 - 2
  parameter S7 = {Y,R,R,Y};  //YRRY	01000001 - 1

  reg [7:0] currentState;
  reg clock; 
  reg flag;
  integer count;
  wire [31:0] limit;
  
  
  always @ (posedge clock or posedge rst) begin
    if(rst)
      currentState <= RST;
    else begin
      case(currentState)
        RST: begin
          currentState <= S0;
          flag <= 1'b0;
        end
		  
		  S0: begin
          currentState <= S1;
          flag <= 1'b1;
        end
        
        S1: begin
          currentState <= S2;
			 flag <= 1'b0;
        end
        
        S2: begin
          currentState <= S3;
			 flag <= 1'b1;
        end
        
        S3: begin
          currentState <= S4;
			 flag <= 1'b0;
        end
		  
		  S4: begin
          currentState <= S5;
			 flag <= 1'b1;
        end
        
        S5: begin
          currentState <= S6;
			 flag <= 1'b0;
        end
        
        S6: begin 
          currentState <= S7;
			 flag <= 1'b1;
        end
        
        S7: begin
          currentState <= S0;
			 flag <= 1'b0;
        end
		  
		  default: begin
          currentState <= RST;
			 flag <= 1'b1;
        end
      endcase
    end
  end
  
  
  always @ (posedge clk or posedge rst) begin  
    if(rst) begin
      count <= 32'd0;
      clock <= 1'b0;
    end
    else begin
      if(count == limit) begin
        clock <= ~clock;
        count <= 32'b0;
      end
      else begin
        clock <= clock;
        count <= count + 1'b1;
      end
    end   
  end
  
  assign limit = (flag == 1'b0) ? ((FREQ / 2) * 5) : (FREQ / 2);
  
  always @ (currentState) begin
    signal <= currentState;
  end
  
endmodule

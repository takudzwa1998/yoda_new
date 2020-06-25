 `timescale 1ns / 1ps
 module BCD_Decoder(
    input [4:0]BCD,
    output reg [6:0]SevenSegment
);
//------------------------------------------------------------------------------
// Combinational circuit to convert BCD input to seven-segment output

// 10 - G
// 11 - E
// 12 - N
// 13 - I
// 14 - R
// 15 - T
// 16 - S
// 17 - O
// 18 - A

always @(BCD) 
begin
case(BCD)
                           // gfedcba
   5'd0 : SevenSegment <= 7'b0111111;  //     a
   5'd1 : SevenSegment <= 7'b0000110;  //    ----
   5'd2 : SevenSegment <= 7'b1011011;  //   |   |
   5'd3 : SevenSegment <= 7'b1001111;  //  f| g |b
   5'd4 : SevenSegment <= 7'b1100110;  //    ----
   5'd5 : SevenSegment <= 7'b1101101;  //   |   |
   5'd6 : SevenSegment <= 7'b1111101;  //  e|   |c
   5'd7 : SevenSegment <= 7'b0000111;  //    ----
   5'd8 : SevenSegment <= 7'b1111111;  //      d
   5'd9 : SevenSegment <= 7'b1101111;
   5'd10: SevenSegment <= 7'b1101111; // G
   5'd11: SevenSegment <= 7'b1111001; // E
   5'd12: SevenSegment <= 7'b0110111; // N
   5'd13: SevenSegment <= 7'b0000110; // I
   5'd14: SevenSegment <= 7'b0110001; // r
   5'd15: SevenSegment <= 7'b1111000; // t
   5'd16: SevenSegment <= 7'b0111111; // O
   5'd17: SevenSegment <= 7'b1110111; // A
   5'd18: SevenSegment <= 7'b0111110; // V
   5'd19: SevenSegment <= 7'b1110001; // F
   5'd20: SevenSegment <= 7'b0000000; // CLEAR
   5'd21: SevenSegment <= 7'b1011110; // D
   // generate - 10,11,12,11,14,17,15,11 
   // navigate - 12,17,18,13,10,17,15,11
   // settings - 5,11,15,15,13,12,10,5
   // info - 13,12,19,16
   
   
 // INIT - 13,12,13,15
// END - 11, 12, 21
// NOS - 12, 16, 5
default: SevenSegment <= 7'b0000000;
endcase
end
//--------------------------------------------------------------
endmodule 

`timescale 1ns / 1ps
module SS_Driver(
    input Clk, input [15:0] Reset,
    input [4:0]BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0, // Binary-coded decimal input
    output reg [7:0] SegmentDrivers, // Digit drivers (active low)//was [3:0] anode
    output reg [7:0] SevenSegment // Segments (active low)//SevenSegment
);

// Make use of a subcircuit to decode the BCD to seven-segment (SS)
wire [6:0]SS[7:0];
BCD_Decoder BCD_Decoder0 (BCD0, SS[0]);
BCD_Decoder BCD_Decoder1 (BCD1, SS[1]);
BCD_Decoder BCD_Decoder2 (BCD2, SS[2]);
BCD_Decoder BCD_Decoder3 (BCD3, SS[3]);
BCD_Decoder BCD_Decoder4 (BCD4, SS[4]);
BCD_Decoder BCD_Decoder5 (BCD5, SS[5]);
BCD_Decoder BCD_Decoder6 (BCD6, SS[6]);
BCD_Decoder BCD_Decoder7 (BCD7, SS[7]);


// Counter to reduce the 100 MHz clock to 762.939 Hz (100 MHz / 2^17)
reg [16:0]Count;
reg state = 0;
integer high = 0;
integer clock = 0;
integer reset = 0;
integer pwm = 20;
reg pwm_out;
integer val;
// Scroll through the digits, switching one on at a time--->
always @(posedge Clk) begin
  clock <= clock + 1;

 //SegmentDrivers <= 8'b00000000; //SegmentDrivers <= 4'hE;
 Count <= Count + 1'b1;
 if ( Reset[0]) SegmentDrivers <=8'hFE;//SegmentDrivers <=4'hE;
 else if(&Count) SegmentDrivers <= {SegmentDrivers[6:0], SegmentDrivers[7]};
end

//------------------------------------------------------------------------------
always @(*) begin // This describes a purely combinational circuit
    val <= Reset[0];
    SevenSegment[7] <= 1'b1; // Decimal point always off
    if (Reset[0]) begin
        SevenSegment[6:0] <= 7'h7F; // All off during Reset
    end else begin
        case(~SegmentDrivers) // Connect the correct signals,
            4'h1   : SevenSegment[6:0] <= ~SS[0]; // depending on which digit is on at
            4'h2   : SevenSegment[6:0] <= ~SS[1]; // this point
            4'h4   : SevenSegment[6:0] <= ~SS[2];
            4'h8   : SevenSegment[6:0] <= ~SS[3];
            8'h10  : SevenSegment[6:0] <= ~SS[4];
            8'h20  : SevenSegment[6:0] <= ~SS[5]; 
            8'h40  : SevenSegment[6:0] <= ~SS[6];
            8'h80  : SevenSegment[6:0] <= ~SS[7];
            default: SevenSegment[6:0] <= 7'h7F;
        endcase
    end
end

endmodule

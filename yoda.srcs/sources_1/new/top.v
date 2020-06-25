`timescale 1ps / 1ps

module top(
input  CLK100MHZ,
input [4:0] button,
input [15:0] SW,
output [7:0] SS_CAT,//SevenSegment
output [7:0] SS_AN, //Segment Drivers was [3:0}
output wire [1:0] LED
    );

function integer poly_1;
input integer x;
 begin
poly_1 = (x * x) + 25 * x;

end

endfunction

//----------- BRAM ------------// 
 // Memory IO
reg ena = 1;
reg wea = 0;
reg [16:0] addra=0;
reg [31:0] dina=0; //Set dina to 1, because we are putting data in
wire [31:0] douta;
    
blk_mem_gen_0 your_instance_name (
  .clka(CLK100MHZ),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [8 : 0] addra
  .dina(dina),    // input wire [10 : 0] dina
  .douta(douta)  // output wire [10 : 0] douta
);
//----------- BRAM ------------// 


integer i;
integer done = 0;
integer sample = 0;

integer clkdiv = 0;
integer temp = 0;
 reg [12:0] counter = 0;
 
 //-------------Initialise Seven Segment------------------//
reg[4:0] one=20;
reg[4:0] two=20;
reg[4:0] three=20;
reg[4:0] four=20;
reg[4:0] five=20;
reg[4:0] six=20;
reg[4:0] seven=20;
reg[4:0] eight=20;
// menu (aka 'panes') = 0 (main menu)
// menu = 1 (setting menu)
// menu = 2 (info)
integer menu = 0;
integer option = 0;
// SET (SUB MENU)
// START
// END
// NOS

integer local = 0;


//p[7:0] lsfr_taps [0 : 7];
reg [4:0] MENU_GEN [0:7];
reg [4:0] MENU_SET [0:7];
reg [4:0] MENU_NFO [0:7];


 // START - 5,15,17,14,15
// END - 11, 12, 21
// NOS - 12, 16, 5

reg [4:0] SET_INIT [0:3];
reg [4:0] SET_END [0:3];
reg [4:0] SET_NOS [0:3];

integer data_init = 0;
integer data_end = 0;
integer data_nos = 0;
integer i_1000 = 0;
integer i_100 = 0;
integer i_10 = 0;
integer i_1 = 0;

integer addr = 0;
integer addr_val = 0;

initial begin
//MENU_GENERATE[0:7] <= {5'd10, 5'd11, 5'd12, 5'd11, 5'd14, 5'd17, 5'd15, 5'd11};
  MENU_GEN[0] <= 5'd10;MENU_GEN[1] <= 5'd11;MENU_GEN[2] <= 5'd12;MENU_GEN[3] <= 5'd20;
  MENU_GEN[4] <= 5'd20;MENU_GEN[5] <= 5'd20;MENU_GEN[6] <= 5'd20;MENU_GEN[7] <= 5'd20;
  
  //settings - 5,51,15,15,13,12,10,5                       5                    5
  MENU_SET[0] <= 5'd5;MENU_SET[1] <=  5'd11;MENU_SET[2] <= 5'd15;MENU_SET[3] <= 5'd20;
  MENU_SET[4] <= 5'd20;MENU_SET[5] <= 5'd20;MENU_SET[6] <= 5'd20;MENU_SET[7] <= 5'd20;

  // info - 13,12519,16               5                    5                    5
  MENU_NFO[0] <= 5'd12;MENU_NFO[1] <= 5'd19;MENU_NFO[2] <= 5'd16;MENU_NFO[3] <= 5'd20;
  MENU_NFO[4] <= 5'd20;MENU_NFO[5] <= 5'd20;MENU_NFO[6] <= 5'd20;MENU_NFO[7] <= 5'd20;
  
   // INIT - 13,12,13,15
// END - 11, 12, 21
// NOS - 12, 16, 5
  SET_INIT[0] <= 5'd13;SET_INIT[1] <= 5'd12;SET_INIT[2] <= 5'd13;SET_INIT[3] <= 5'd15;
  SET_END[0] <= 5'd11;SET_END[1] <= 5'd12;SET_END[2] <= 5'd21;SET_END[3] <= 5'd20;
  SET_NOS[0] <= 5'd12;SET_NOS[1] <= 5'd16;SET_NOS[2] <= 5'd5;SET_NOS[3] <= 5'd20;

end

wire arp_switch;

wire btn_up;
reg last_state_btn_up;

wire btn_down;
reg last_state_btn_down;

wire btn_left;
reg last_state_btn_left;

wire btn_right;
reg last_state_btn_right;

wire btn_select;
reg last_state_btn_select;


Debounce up(CLK100MHZ,     button[0], btn_up);
Debounce down(CLK100MHZ,   button[1], btn_down);
Debounce left(CLK100MHZ,   button[2], btn_left);
Debounce right(CLK100MHZ,  button[3], btn_right);
Debounce select(CLK100MHZ, button[4], btn_select);


SS_Driver SS_Driver1(CLK100MHZ, SW[0], one, two, three, four,
                    five, six, seven, eight,
                    SS_AN, SS_CAT
                    );
 
 //-------------Initialise Seven Segment------------------//	
 
always @(posedge CLK100MHZ)begin
/*
clkdiv=clkdiv+1;
    if (clkdiv >= 100000000)begin
        dina<= counter+1;
        addra<=addra+1;
        one<= one+1;two<= two+1;three<= three+1;four<= four+1;
        five<= five+1;six<= six+1;seven<= seven+1;
        eight<= eight+1;
        clkdiv<= 0;
    end
    
    
    
*/
case (menu)

// MAIN MENU
4'd0: begin

if(btn_left)begin
    option<= option+1;
end

if (btn_right)begin
   option<= option - 1;
end

if(btn_select && option == 0)begin

menu = 1;
end

else if (btn_select && option == 1)begin
menu = 2;
option = 0;
end

else if (btn_select && option == 2)begin
menu = 3;
end


if(option >3)begin
option <= 0;
end

if(option <0)begin
option <=3;
end


case (option)
4'd0: begin
    one = MENU_GEN[0];   two = MENU_GEN[1];
    three=MENU_GEN[2];   four=MENU_GEN[3];
    five = MENU_GEN[4];  six=MENU_GEN[5];
    seven = MENU_GEN[6]; eight=MENU_GEN[7];
    end
4'd1: begin
    one = MENU_SET[0];   two = MENU_SET[1];
    three=MENU_SET[2];   four=MENU_SET[3];
    five = MENU_SET[4];  six=MENU_SET[5];
    seven = MENU_SET[6]; eight=MENU_SET[7];
    end
4'd2: begin
    one = MENU_NFO[0];   two = MENU_NFO[1];
    three=MENU_NFO[2];   four=MENU_NFO[3];
    five = MENU_NFO[4];  six=MENU_NFO[5];
    seven = MENU_NFO[6]; eight=MENU_NFO[7];
    end
endcase
end

// BRAM EXPLORER
4'd1: begin

if(btn_up)begin
addr <= addr + 1;
end

if(btn_down)begin
addr <=  addr - 1;
end

if(addr >9999)begin
addr <= 0;
end

if(addr <0)begin
addr <=9999;
end

if(btn_select)begin
menu = 0;
end

if (i < data_nos)begin
addra = i;
wea = 1;
// start 0
// end 600
// samples 10
//poly_1 = (x * x) + 25 * x;
// (x* x) + 25 * x

// 0 + 1 * (600)/10
// poly_1 = (x * x) + 25 * x;
local =  data_init + ( (i*(data_end-data_init) )/ data_nos );
dina =  (local * local) + (25)*local ;
i <= i + 1;
end


else begin

wea = 0;
    // Display Address (LEFT 4)
    temp = addr;
    addra = addr;
    // 1250
     i_1000 = temp / 1000; // = 1
     // temp = 1250 - 1000 = 250
     temp = temp - i_1000 * 1000;
     i_100 = temp / 100; // = 2
     // temp = 250 - 200 = 50
     temp = temp - i_100 * 100;
     i_10 = temp / 10; // = 5
     // temp = 50 - 50 = 0
     temp = temp - i_10 * 10;
     i_1 = temp;
    // 120/10 = 12
    one <= i_1000;   
    two <=  i_100;
    three <=i_10;
    four <=i_1;
    
    
    //@(posedge  CLK100MHZ);
    // Display value @ ADDR (RIGHT 4)
      temp = douta;
    // 1250
     i_1000 = temp / 1000; // = 1
     // temp = 1250 - 1000 = 250
     temp = temp - i_1000 * 1000;
     i_100 = temp / 100; // = 2
     // temp = 250 - 200 = 50
     temp = temp - i_100 * 100;
     i_10 = temp / 10; // = 5
     // temp = 50 - 50 = 0
     temp = temp - i_10 * 10;
     i_1 = temp;
    // 120/10 = 12
    five <= i_1000;   
    six <=  i_100;
    seven <=i_10;
    eight <=i_1;
    
    
end
end


// SETTINGS
4'd2: begin
if(btn_left)begin
    option<= option+1;
end

if (btn_right)begin
   option<= option - 1;
end
if(btn_select)begin
menu = 0;
end

if(btn_up && option == 0)begin
data_init <= data_init + 10;
end
if(btn_up && option == 1)begin
data_end <= data_end + 10;
end
if(btn_up && option == 2)begin
data_nos <= data_nos + 1;
end


if(btn_down && option == 0)begin
data_init <= data_init - 10;
end
if(btn_down && option == 1)begin
data_end <= data_end - 10;
end
if(btn_down && option == 2)begin
data_nos <= data_nos - 1;
end

if(option >3)begin
option <= 0;
end

if(option <0)begin
option <=3;
end

case (option)
4'd0: begin



// data_init =  500
// 500 0
// 50 0
// 5 5
// 
// 500 >> 2 = 5
// 500 >> 2
    one = SET_INIT[0];   two = SET_INIT[1];
    three=SET_INIT[2];   four=SET_INIT[3];
    five = 20;          six=20;
    seven = 20;         eight=20;
    temp = data_init;
    // 1250
     i_1000 = temp / 1000; // = 1
     // temp = 1250 - 1000 = 250
     temp = temp - i_1000 * 1000;
     i_100 = temp / 100; // = 2
     // temp = 250 - 200 = 50
     temp = temp - i_100 * 100;
     i_10 = temp / 10; // = 5
     // temp = 50 - 50 = 0
     temp = temp - i_10 * 10;
     i_1 = temp;
    // 120/10 = 12
    five <= i_1000;   
    six <=  i_100;
    seven <=i_10;
    eight <=i_1;

    end
4'd1: begin
    one = SET_END[0];   two = SET_END[1];
    three=SET_END[2];   four=SET_END[3];
    five = 20;          six=20;
    seven = 20;         eight=20;
    
      temp = data_end;
    // 1250
     i_1000 = temp / 1000; // = 1
     // temp = 1250 - 1000 = 250
     temp = temp - i_1000 * 1000;
     i_100 = temp / 100; // = 2
     // temp = 250 - 200 = 50
     temp = temp - i_100 * 100;
     i_10 = temp / 10; // = 5
     // temp = 50 - 50 = 0
     temp = temp - i_10 * 10;
     i_1 = temp;
    // 120/10 = 12
    five <= i_1000;   
    six <=  i_100;
    seven <=i_10;
    eight <=i_1;
    
    end


4'd2: begin
    one = SET_NOS[0];   two = SET_NOS[1];
    three=SET_NOS[2];   four=SET_NOS[3];
    five = 20;          six=20;
    seven = 20;         eight=20;
    
      temp = data_nos;
    // 1250
     i_1000 = temp / 1000; // = 1
     // temp = 1250 - 1000 = 250
     temp = temp - i_1000 * 1000;
     i_100 = temp / 100; // = 2
     // temp = 250 - 200 = 50
     temp = temp - i_100 * 100;
     i_10 = temp / 10; // = 5
     // temp = 50 - 50 = 0
     temp = temp - i_10 * 10;
     i_1 = temp;
    // 120/10 = 12
    five <= i_1000;   
    six <=  i_100;
    seven <=i_10;
    eight <=i_1;
    end
endcase

end
endcase
end
 
 endmodule

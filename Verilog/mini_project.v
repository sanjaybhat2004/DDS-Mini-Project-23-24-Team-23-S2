module parkingLot(entryTime1, entryTime2, entryTime3, 
                    getParkingLot, incomingVehicle);

    // We keep separate registers for all different parking lots for entry times 
    input [0:3] entryTime1;
    input [0:3] entryTime2;
    input [0:3] entryTime3;

    // register to keep data of available parking lots
    reg [0:3] availableParkingLot;
    input [0:0] incomingVehicle;
    output [0:3] getParkingLot;

    initial begin
        // initially all parking lots are available
        availableParkingLot = 4'b1111;
    end
    

    assign getParkingLot[0] = availableParkingLot[0];
    assign getParkingLot[1] = !availableParkingLot[0] && availableParkingLot[1];
    assign getParkingLot[2] = !availableParkingLot[0] && !availableParkingLot[1] 
                                && availableParkingLot[2];
    assign getParkingLot[3] = !availableParkingLot[0] && !availableParkingLot[1] 
                                && !availableParkingLot[2] && availableParkingLot[3];
    

    // getParkingLot gives the index of the parking lot to choose by checking which all parking lots are available
    // if more than one parkign lots are available then the parking lot with the least index is choosen 


    // displays status of all parking lots, if any changes occur
    always @(availableParkingLot[0], availableParkingLot[1], availableParkingLot[2], availableParkingLot[3]) 
        $display("Current Parking Lot availability: %b | %b | %b | %b", availableParkingLot[0], availableParkingLot[1], availableParkingLot[2], availableParkingLot[3]);
    

    initial #5 availableParkingLot[0] = 1'b0;

endmodule

module rippleCarryAdder(
    // module for adding two 4-bit numbers
    input [3:0]a,b,
    input cin,
    output [3:0]sum,
    output c4);

wire c1,c2,c3;      

FA fa0(sum[0],c1,a[0],b[0],cin);
FA fa1(sum[1],c2,a[1],b[1],c1);
FA fa2(sum[2],c3,a[2],b[2],c2);
FA fa3(sum[3],c4,a[3],b[3],c3);
                
endmodule

module add_sub(
    // circuit for subtracting two numbers
    // used to find out duration of stay by subtracting current time with entry time
    input subtractor,
    input [3:0]A,B,
    output [3:0]sum_diff,
    output carry_brrow
);

wire [3:0]Bmod;
assign Bmod = {4{subtractor}} ^ B;
rippleCarryAdder rca0(A,Bmod,subtractor,sum_diff,carry_brrow);

endmodule


module multiplier4x4(product,inp1);
    // module which multiplies two 4-bit binary numbers
    // used when multiplying cost of parking lot per hour with duration of stay

    output [7:0]product;
    input [3:0]inp1;
    reg [3:0] inp2;
    
    initial inp2 = 4'b0010;

    assign product[0]=(inp1[0]&inp2[0]);
    
    wire x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17;
    
    HA HA1(product[1],x1,(inp1[1]&inp2[0]),(inp1[0]&inp2[1]));
    FA FA1(x2,x3,inp1[1]&inp2[1],(inp1[0]&inp2[2]),x1);
    FA FA2(x4,x5,(inp1[1]&inp2[2]),(inp1[0]&inp2[3]),x3);
    HA HA2(x6,x7,(inp1[1]&inp2[3]),x5);
    
    HA HA3(product[2],x15,x2,(inp1[2]&inp2[0]));
    FA FA5(x14,x16,x4,(inp1[2]&inp2[1]),x15);
    FA FA4(x13,x17,x6,(inp1[2]&inp2[2]),x16);
    FA FA3(x9,x8,x7,(inp1[2]&inp2[3]),x17);
    
    HA HA4(product[3],x12,x14,(inp1[3]&inp2[0]));
    FA FA8(product[4],x11,x13,(inp1[3]&inp2[1]),x12);
    FA FA7(product[5],x10,x9,(inp1[3]&inp2[2]),x11);
    FA FA6(product[6],product[7],x8,(inp1[3]&inp2[3]),x10);
  
endmodule

module HA(sout,cout,a,b);
    // half adder module
    output sout,cout;
    input a,b;
    assign sout=a^b;
    assign cout=(a&b);
endmodule

module FA(sout,cout,a,b,cin);
    // full adder module
    output sout,cout;
    input a,b,cin;
    assign sout=(a^b^cin);
    assign cout=((a&b)|(a&cin)|(b&cin));  
endmodule   

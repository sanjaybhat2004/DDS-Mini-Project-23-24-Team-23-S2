 # DDS-miniproject-T4 - AGRI RAIN ALARM SYSTEM


## Team Members
<details>
 
  *  221CS245, Sanjay Bhat, <sanjay.221cs245@nitk.edu.in>, 7019608367
  *  221CS256, Tarun D Joshi, <tarundjoshi.221cs256@nitk.edu.in>, 9108250643
 
</details>


## Abstract :


<details>


The Car Parking Lot System project is a cutting-edge solution designed to streamline the
parking experience in valet controlled parking lots. This innovative system uses very simple yet
effective technology to enhance efficiency, convenience, and security for both vehicle owners
and parking lot operators.
Key features of the Car Parking Lot System include:
Automated Entry and Exit :
The system automatically takes care of the entry time and exit time without anyone present to
record it. The system can be integrated with Machine Learning or similar algorithms which allow
seamless counting of cars based on the parking lot assigned to it . This way it can be fully
automated . This model however is based on a simpler implementation which does not use such
algorithms and requires the valet to select the entry and exit of a car.
Contactless Payment: Users can pay for parking digitally through mobile apps or online
platforms, eliminating the need for cash transactions and reducing waiting times. The cost to be
paid is displayed by a digital monitor and can be integrated to only allow passage if the money
was fully paid. (Similar to fastag in the modern era).
Sustainability: The system can be integrated with energy-efficient lighting and eco-friendly
materials, reducing the environmental impact of the parking lot.
Easy Access of lots :
This system efficiently picks out an available parking lot number and displays to move there .
This way we need not worry if there is availability of parking lots inside and can simply rely on
the system to tell us this information. Further if available we need not to take the car inside and
look for an empty lot since the empty plot number is already assigned to the car by the system.
The Car Parking Lot System optimizes the use of available space, reduces congestion, and
provides a convenient and hassle-free experience for users, making it a valuable addition to
modern urban infrastructure.


</details>




## Working


<details>
  ### Functional Table
 <details>


 </details>
</details>


## Logisim Circuit Diagram :


<details>


</details>




##  Verilog :
<details>
 
  ### Module :


```verilog
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




```


### TestBenche :
```verilog
module mini_project_tb;


    wire [0:7] costOfStay;
    reg [0:3]  entryTime1;
    reg [0:3] entryTime2;
    reg [0:3] entryTime3;
    wire [0:3] getParkingLot;
    reg [0:3] timeElapsed;
    reg [0:0] incomingVehicle;
    reg[0:3] setParkingLot;
    wire [0:3] durationOfStay;
    reg subtractor;


    initial begin
        $dumpfile("mini_project.vcd");
        $dumpvars(0, mini_project_tb);
    end


    parkingLot pL (entryTime1, entryTime2, entryTime3, 
    getParkingLot, incomingVehicle);




    wire carry_brrow;
    add_sub uut(subtractor, timeElapsed, entryTime1, durationOfStay, carry_brrow);
    multiplier4x4 multiplier(costOfStay, durationOfStay);


    initial begin
 
        
        $monitor("Get free parking lot:| %b | %b | %b | %b | \nCurrent duration of Stay: %d \nCurrent cost of Stay: %d", getParkingLot[0], getParkingLot[1],
        getParkingLot[2], getParkingLot[3], durationOfStay, costOfStay);




        timeElapsed = 4'b0000;


        #2
        repeat (2) timeElapsed = timeElapsed + 4'b0001; 
        incomingVehicle = 1'b1;


        //Entry of car in parking lot
        $display("New vehicle in parking lot: %b", incomingVehicle[0]); 




        $display("Vehicle is sent to parking lot which is free");
        entryTime1 = timeElapsed;


        #3
        repeat (3) timeElapsed = timeElapsed + 4'b0001;
        //vehicle stays in parking lot for 3 hours


        // subtractor = 1 makes the 
        subtractor = 1;


    end


    initial #2000 $finish;




endmodule






```












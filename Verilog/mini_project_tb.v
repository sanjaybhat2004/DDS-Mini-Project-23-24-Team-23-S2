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
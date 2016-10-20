`timescale 1ns / 1ns
module Controller (sysclk,reset,RX_DATA,RX_STATUS,TX_STATUS,TX_DATA,TX_EN);

  input [7:0] RX_DATA;
  input reset,sysclk,RX_STATUS,TX_STATUS;
  output reg [7:0] TX_DATA;
  output reg TX_EN;

  reg [7:0] temp;
  
  reg [2:0] state;
  initial
	state<=2'd3;
  
  always @ (posedge sysclk or posedge RX_STATUS)
  begin
	if(RX_STATUS)
		state<=2'd0;				//first status,have receivered data
	else if(TX_STATUS&&state==2'd0)
		state<=2'd1;      			//second status,can start to send data
	else if(state==2'd1)
		state<=2'd2;      			//third status,hava sent data
  end
  
 
  always @ (posedge sysclk or posedge RX_STATUS)
  begin
	  if(RX_STATUS)					//have receivered data,store it to temp register
	  begin
	  #1
	  temp[7]<=RX_DATA[7];
	  temp[6:0]<=(RX_DATA[7]==1)?~RX_DATA[6:0]:RX_DATA[6:0];
	  end
  end
  
  always @ (state)
  begin
    case(state)
	2'd0:TX_EN<=0;
	2'd1:							//start to send data
	begin
	TX_EN<=1;
	TX_DATA<=temp;
	end
	2'd2:TX_EN<=0;
	default:TX_EN<=0;
	endcase
  end

endmodule

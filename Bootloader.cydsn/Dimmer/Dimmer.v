////////////////////////////////////////////////////////////////////
//`#start header` -- edit after this line, do not edit this line
`include "cypress.v"
//`#end` -- edit above this line, do not edit this line
////////////////////////////////////////////////////////////////////
//`#start body` -- edit after this line, do not edit this line
////////////////////////////////////////////////////////////////////
module Dimmer( ena, clk, dim, led );
  //parameter DIM_LO = 26;   //10% * 256 
  //parameter DIM_HI = 218;  //85% * 256
  parameter DIM_LO = 5;   //10% * 256 
  parameter DIM_HI = 250;  //85% * 256 
  input	 ena;	// enable
  input	 clk;	// base clock
  input  dim;	// dimming clock
  output led;	// led drive
  reg      out;	// output toggle 
  reg[7:0] pwm;	// PWM counter
  reg[7:0] cmp;	// compare value
  reg      upd;	// up or down
  
 assign led= out;	// toggle wire to the led 
 
////////////////////////////////////////////////////////////////////
 always @( posedge clk ) begin	// base clock
  if( ena==1 ) begin	// when enable
	pwm= pwm+1;			// pwm up count always
	if( pwm<cmp ) begin
	  out= 1;			// less than cmp lit
	end else begin
	  out= 0;			// greater than, turn off
	end
  end else begin
	out= 0;				// when disable, turn off  
  end
 end

////////////////////////////////////////////////////////////////////
 always @( posedge dim ) begin	// dimmer clock
  if( ena==1 ) begin	// when enable
   if( upd==1 ) begin	//  and up ward
	cmp= cmp+1;			//  increase compare value
	if( cmp>DIM_HI ) begin	// upper limit check (85%)
	  upd= 0;				// switch to up ward
	end else begin
	  upd= 1;				// else down ward
	end
   end else begin		// down ward
	cmp= cmp-1;			//  decrease compare
	if( cmp<DIM_LO ) begin  // lower limit check (10%)
	  upd= 1;
	end else begin
	  upd= 0;
	end
   end 
  
  end else begin
     cmp= cmp; 			// disable, keep compare value 
  end
 end
   
endmodule
////////////////////////////////////////////////////////////////////
//`#end` -- edit above this line, do not edit this line
////////////////////////////////////////////////////////////////////
//`#start footer` -- edit after this line, do not edit this line
//`#end` -- edit above this line, do not edit this line
////////////////////////////////////////////////////////////////////
//[] END OF FILE
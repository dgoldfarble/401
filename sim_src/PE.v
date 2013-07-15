module PE	(	// inputs
				Grant_IN,
				Request_IN,
				Grant_OUT,
				Request_OUT
			);

parameter x_to_one = 4; // not actually parametrized >.>

input	Grant_IN;
input [x_to_one-1:0] Request_IN;

output [x_to_one-1:0] Grant_OUT;
output	Request_OUT;

always begin
	if(|Request_IN) // reduction OR
		Request_OUT = 1;
	else
		Request_OUT = 0;
	
	if(Grant_IN) begin
		Grant_OUT[0] = Request_IN[0];
		Grant_OUT[1] = Request_IN[1]&&(!Request_IN[0]);
		Grant_OUT[2] = Request_IN[2]&&(!Request_IN[1])&&(!Request_IN[0]);
		Grant_OUT[3] = Request_IN[3]&&(!Request_IN[2])&&(!Request_IN[1])&&(!Request_IN[0]);
	end
end

endmodule

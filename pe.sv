// ========================================================================
// ==================== PARAMETERIZED PRIORITY ENCODER ====================
// ========================================================================

module priority_encoder #(
	parameter DATA_LEN = 8,
	parameter RESULT_LEN = 3
	)(
	// System Signals
	input wire 							rst,
	input wire 							clk,
	
	// Control Signals
	input wire 							dut_start,
	output wire 						dut_ready,
	output wire							dut_done,
	
	// Input
	input wire [DATA_LEN-1:0]			data_in,
	// output
	output wire [RESULT_LEN-1:0]		result,
	output wire 						zero_f
	);


	
	// Control Signals register
	reg							dut_start_r;
	reg 						dut_ready_r;
	reg 						dut_done_r;
	// Input register
	reg [DATA_LEN-1:0]			data_in_r;
	// Output register
	reg [RESULT_LEN-1:0]		result_r;
	reg 						zero_f_r;	
	
	
	reg [DATA_LEN-1:0] data;
	reg [RESULT_LEN-1:0] count;
	reg MSB_check = 0;
	reg eval = 0;
	
	
	// States
	parameter [2:0]
		S0 = 2'b00,
		S1 = 2'b01,
		S2 = 2'b10,
		S3 = 2'b11;
	
	reg [2:0] current_state, next_state;
	
	always @(posedge clk) begin
		if (!rst) current_state <= S0;
		else begin 
			current_state <= next_state;
			dut_start_r <= dut_start;
			data_in_r <= data_in;
		end
	end
	
	always @(*) begin
		case (current_state)
			S0: begin
					data <= 0;
					count <= 0;
					dut_done_r <= 0;
					dut_ready_r <= 1;
					MSB_check <= 0;
					result_r <= 'x;
					zero_f_r <= 0;
					if (dut_start_r) next_state <= S1;
					else next_state <= S0;
				end
			S1: begin
					data <= data_in_r;
					count <= DATA_LEN-1;
					dut_done_r <= 0;
					dut_ready_r <= 0;
					next_state <= S2;
				end
			S2: begin
					dut_done_r <= 0;
					dut_ready_r <= 0;
					if (data[count]) begin
						next_state <= S3;
						eval <= 0;
					end
					else if (count == 0) begin
						next_state <= S3;
						eval <= 0;
						zero_f_r <= 1;
					end
					else begin
						next_state <= S2;
						eval <= 1;
					end
				end
			S3: begin
					MSB_check <= 0;
					eval <= 0;
					if (!zero_f_r) result_r <= count;
					dut_done_r <= 1;
					dut_ready_r <= 0;
					next_state <= S0;
				end
		endcase
	end
	
	always @(posedge clk) begin
		if (data[count]) MSB_check <= 1;
		
		if (!MSB_check && eval) count <= count - 1;
	end
	
	assign result = result_r;
	assign dut_done = dut_done_r;
	assign dut_ready = dut_ready_r;
	assign zero_f = zero_f_r;

endmodule
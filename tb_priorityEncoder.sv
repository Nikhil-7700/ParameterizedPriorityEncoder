module tb_pe();

	parameter DATA_LEN = 20;
	parameter RESULT_LEN = $ceil($clog2(DATA_LEN));
	
	$info("The parameter for the input length is %0d", DATA_LEN);
		
	
	//int RESULT_LEN = $ceil($clog2(DATA_LEN));
	
	logic rst;
	logic clk;
	
	logic dut_start;
	logic dut_ready;
	logic dut_done;
	
	logic [DATA_LEN - 1 :0] data_in;
	logic [RESULT_LEN - 1 : 0] result;
	logic zero_f;
	
	//int DATA_LEN, RESULT_LEN;
	
	
	
	priority_encoder #(.DATA_LEN(DATA_LEN), .RESULT_LEN(RESULT_LEN)) dut(.clk(clk), .rst(rst), .data_in(data_in), .result(result), .dut_start(dut_start), .dut_ready(dut_ready), .dut_done(dut_done), .zero_f(zero_f));
	
	//always #5 clk = ~clk;
	
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end
	
	initial begin
		rst = 1'b0;
		#27 rst = 1'b1;
		
		//repeat(20) begin
			data_in = 20'b00000011010101001101;
			#5 dut_start = 1'b1;
			#10 dut_start = 1'b0;
			$display("Running the priority encoder for %0b", data_in);
			wait(dut_done)
			wait(!dut_done)
			$display("The result for data %0b is %0b; %0d", data_in, result, result);
			
			#100;
			
			
			data_in = 20'b00000000010111000011;
			#5 dut_start = 1'b1;
			#10 dut_start = 1'b0;
			$display("Running the priority encoder for %0b", data_in);
			wait(dut_done)
			wait(!dut_done)
			$display("The result for data %0b is %0b; %0d", data_in, result, result);
			
			#100;
			
			data_in = 20'b0;
			#5 dut_start = 1'b1;
			#10 dut_start = 1'b0;
			$display("Running the priority encoder for %0b", data_in);
			wait(dut_done)
			wait(!dut_done)
			$display("The result for data %0b is %0b; %0d ---- zero flag: %b", data_in, result, result, zero_f);
			
			#100;
			
			data_in = 20'b10000000010111000011;
			#5 dut_start = 1'b1;
			#10 dut_start = 1'b0;
			$display("Running the priority encoder for %0b", data_in);
			wait(dut_done)
			wait(!dut_done)
			$display("The result for data %0b is %0b; %0d ---- zero flag: %b", data_in, result, result, zero_f);
			
			#100;
			
		//end
		
		$finish;
	end
endmodule

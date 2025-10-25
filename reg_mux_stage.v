module reg_mux_stage (data,clk,rst,mux_out,clk_en,sel);

	parameter D_WIDTH = 18;
	parameter RSTTYPE = "SYNC";

	input [D_WIDTH-1 : 0] data;
	input rst,clk,clk_en,sel;
	output [D_WIDTH-1 : 0] mux_out;

	reg [D_WIDTH-1 : 0] data_reg;

	assign mux_out = (sel) ? data_reg : data;

	generate
		if (RSTTYPE == "SYNC") begin
			always @(posedge clk) begin
				if (rst)
					data_reg <= 0;
				else if (clk_en)
					data_reg <= data;
			end
		end else if (RSTTYPE == "ASYNC") begin
			always @(posedge clk or posedge rst) begin
				if (rst)
					data_reg <= 0;
				else if (clk_en)
					data_reg <= data;
			end
		end
	endgenerate

endmodule : reg_mux_stage
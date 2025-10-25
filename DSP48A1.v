module DSP48A1 (A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEP,CEOPMODE
	           ,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTP,RSTOPMODE,BCIN,BCOUT,PCIN,PCOUT);

	parameter A0REG=0, A1REG=1, B0REG=0, B1REG=1, CREG=1, DREG=1, MREG=1, PREG=1, CARRYINREG=1, CARRYOUTREG=1, OPMODEREG=1;
	parameter CARRYINSEL = "OPMODE5", B_INPUT = "DIRECT", RSTTYPE = "SYNC";

	input [17:0] A,B,D,BCIN;
	input [47:0] C,PCIN;
	input CARRYIN,CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEP,CEOPMODE,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTP,RSTOPMODE;
	input [7:0] OPMODE;
	output [35:0] M;
	output [47:0] P,PCOUT;
	output [17:0] BCOUT;
	output CARRYOUT,CARRYOUTF;

	wire [17:0] A0_mux_out,B0_mux1_out,D_mux_out,B0_mux0_out,ALU0_out,mux_opmode4_out,B1_mux_out,A1_mux_out;
	wire [47:0] C_mux_out,ALU1_out;
	wire [35:0] multiply_out,M_mux_out;
	wire [7:0] OPMODE_mux_out;
	wire mux_carryin_out,Cin_mux_out,CYO,CYO_mux_out;
	reg [47:0] mux_x_out,mux_z_out;

	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(18)) A0_SIG (A,CLK,RSTA,A0_mux_out,CEA,A0REG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(18)) B0_SIG (B0_mux0_out,CLK,RSTB,B0_mux1_out,CEB,B0REG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(48)) C_SIG (C,CLK,RSTC,C_mux_out,CEC,CREG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(18)) D_SIG (D,CLK,RSTD,D_mux_out,CED,DREG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(8)) OPMODE_SIG (OPMODE,CLK,RSTOPMODE,OPMODE_mux_out,CEOPMODE,OPMODEREG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(18)) A1_SIG (A0_mux_out,CLK,RSTA,A1_mux_out,CEA,A1REG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(18)) B1_SIG (mux_opmode4_out,CLK,RSTB,B1_mux_out,CEB,B1REG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(36)) M_SIG (multiply_out,CLK,RSTM,M_mux_out,CEM,MREG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(1)) CYI_SIG (mux_carryin_out,CLK,RSTCARRYIN,Cin_mux_out,CECARRYIN,CARRYINREG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(1)) CYO_SIG (CYO,CLK,RSTCARRYIN,CYO_mux_out,CECARRYIN,CARRYOUTREG);
	reg_mux_stage #(.RSTTYPE(RSTTYPE),.D_WIDTH(48)) P_SIG (ALU1_out,CLK,RSTP,PCOUT,CEP,PREG);


	assign B0_mux0_out = (B_INPUT == "DIRECT") ? B :
						 (B_INPUT == "CASCADE") ? BCIN : 0;

	assign ALU0_out = (OPMODE_mux_out[6] == 0) ? (D_mux_out + B0_mux1_out) : (D_mux_out - B0_mux1_out);
	assign mux_opmode4_out = (OPMODE_mux_out[4] == 0) ? B0_mux1_out : ALU0_out;
	assign BCOUT = B1_mux_out;
	assign multiply_out = A1_mux_out * B1_mux_out;
	assign M = M_mux_out;
	assign mux_carryin_out = (CARRYINSEL == "CARRYIN") ? CARRYIN :
							 (CARRYINSEL == "OPMODE5") ? OPMODE_mux_out[5] : 0;

	always @(*) begin
		case (OPMODE_mux_out[1:0])
			2'b00 : mux_x_out = 0;
			2'b01 : mux_x_out = {{12{1'b0}},M_mux_out};
			2'b10 : mux_x_out = PCOUT;
			2'B11 : mux_x_out = {D_mux_out[11:0],A1_mux_out,B1_mux_out};
			default : mux_x_out = 0;
		endcase

		case (OPMODE_mux_out[3:2])
			2'b00 : mux_z_out = 0;
			2'b01 : mux_z_out = PCIN;
			2'b10 : mux_z_out = PCOUT;
			2'b11 : mux_z_out = C_mux_out;
			default : mux_z_out = 0;
		endcase
	end

	assign {CYO,ALU1_out} = (OPMODE_mux_out[7]) ? (mux_z_out - (mux_x_out+Cin_mux_out)) : (mux_x_out + mux_z_out + Cin_mux_out);
	assign CARRYOUT = CYO_mux_out;
	assign CARRYOUTF = CYO_mux_out;
	assign P = PCOUT; 


endmodule : DSP48A1
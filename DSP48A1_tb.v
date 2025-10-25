module DSP48A1_tb ();

	reg [17:0] A,B,D,BCIN;
	reg [47:0] C,PCIN;
	reg CARRYIN,CLK,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEP,CEOPMODE,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTP,RSTOPMODE;
	reg [7:0] OPMODE;

	wire [35:0] M;
	wire [47:0] P,PCOUT;
	wire [17:0] BCOUT;
	wire CARRYOUT,CARRYOUTF;

	reg [35:0] M_exp;
	reg [47:0] P_exp,PCOUT_exp;
	reg [17:0] BCOUT_exp;
	reg CARRYOUT_exp,CARRYOUTF_exp;

	DSP48A1 dut (A,B,C,D,CARRYIN,M,P,CARRYOUT,CARRYOUTF,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEP,CEOPMODE
	            ,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTP,RSTOPMODE,BCIN,BCOUT,PCIN,PCOUT);

	initial begin
		CLK = 0;
		forever #5 CLK = ~CLK;
	end

	initial begin
		// reset check
		RSTA = 1; RSTB = 1; RSTC = 1; RSTD = 1; RSTM = 1; RSTP = 1; RSTOPMODE = 1; RSTCARRYIN = 1;

		A = $random(); B = $random(); C = $random(); D = $random(); 
		BCIN = $random(); CARRYIN = $random(); PCIN = $random(); OPMODE = $random();

		CEA = $random(); CEB = $random(); CEC = $random(); CED = $random(); CECARRYIN = $random();CEM = $random(); 
		CEP = $random(); CEOPMODE = $random();

		M_exp = 0; P_exp = 0; PCOUT_exp = 0; BCOUT_exp = 0; CARRYOUT_exp = 0; CARRYOUTF_exp = 0;

		@(negedge CLK);

		if ((M == M_exp) && (P == P_exp) && (PCOUT == PCOUT_exp) && (BCOUT == BCOUT_exp) &&
			(CARRYOUT == CARRYOUT_exp) && (CARRYOUTF == CARRYOUTF_exp))
			$display("reset test passed");
		else begin
			$display("error in reset");
			$stop();
		end

		RSTA = 0; RSTB = 0; RSTC = 0; RSTD = 0; RSTM = 0; RSTP = 0; RSTOPMODE = 0; RSTCARRYIN = 0;
		CEA = 1; CEB = 1; CEC = 1; CED = 1; CECARRYIN = 1; CEM = 1; CEP = 1; CEOPMODE = 1;

		// path 1 test
		A = 20; B = 10; C = 350; D = 25; 
		BCIN = $random(); CARRYIN = $random(); PCIN = $random(); OPMODE = 8'b1101_1101;

		M_exp = 'h12c; P_exp = 'h32; PCOUT_exp = 'h32; BCOUT_exp = 'hf; CARRYOUT_exp = 0; CARRYOUTF_exp = 0;

		repeat (4) @(negedge CLK);

		if ((M == M_exp) && (P == P_exp) && (PCOUT == PCOUT_exp) && (BCOUT == BCOUT_exp) &&
			(CARRYOUT == CARRYOUT_exp) && (CARRYOUTF == CARRYOUTF_exp))
			$display("path 1 test passed");
		else begin
			$display("error in path 1");
			$stop();
		end

		// path 2 test
		A = 20; B = 10; C = 350; D = 25; 
		BCIN = $random(); CARRYIN = $random(); PCIN = $random(); OPMODE = 8'b0001_0000;

		M_exp = 'h2bc; P_exp = 0; PCOUT_exp = 0; BCOUT_exp = 'h23; CARRYOUT_exp = 0; CARRYOUTF_exp = 0;

		repeat (3) @(negedge CLK);

		if ((M == M_exp) && (P == P_exp) && (PCOUT == PCOUT_exp) && (BCOUT == BCOUT_exp) &&
			(CARRYOUT == CARRYOUT_exp) && (CARRYOUTF == CARRYOUTF_exp))
			$display("path 2 test passed");
		else begin
			$display("error in path 2");
			$stop();
		end
	

		// path 3 test
		A = 20; B = 10; C = 350; D = 25; 
		BCIN = $random(); CARRYIN = $random(); PCIN = $random(); OPMODE = 8'b0000_1010;

		M_exp = 'hc8; P_exp = 0; PCOUT_exp = 0; BCOUT_exp = 'ha; CARRYOUT_exp = 0; CARRYOUTF_exp = 0;

		repeat (3) @(negedge CLK);

		if ((M == M_exp) && (P == P_exp) && (PCOUT == PCOUT_exp) && (BCOUT == BCOUT_exp) &&
			(CARRYOUT == CARRYOUT_exp) && (CARRYOUTF == CARRYOUTF_exp))
			$display("path 3 test passed");
		else begin
			$display("error in path 3");
			$stop();
		end
	

		// path 4 test
		A = 5; B = 6; C = 350; D = 25; 
		BCIN = $random(); CARRYIN = $random(); PCIN = 3000; OPMODE = 8'b10100111;

		M_exp = 'h1e; P_exp = 'hfe6fffec0bb1; PCOUT_exp = 'hfe6fffec0bb1; 
		BCOUT_exp = 'h6; CARRYOUT_exp = 1; CARRYOUTF_exp = 1;

		repeat (3) @(negedge CLK);

		if ((M == M_exp) && (P == P_exp) && (PCOUT == PCOUT_exp) && (BCOUT == BCOUT_exp) &&
			(CARRYOUT == CARRYOUT_exp) && (CARRYOUTF == CARRYOUTF_exp))
			$display("path 4 test passed");
		else begin
			$display("error in path 4");
			$stop();
		end
	

		$display("TEST PASSED :)");
		$stop();
	end

endmodule : DSP48A1_tb
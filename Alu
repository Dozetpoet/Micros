module tb_adder_4b;
  reg [3:0] A, B;
  reg C_in;
  wire [3:0] Sum;
  wire C_out;

  adder_4b uut (
    .A(A),
    .B(B),
    .C_in(C_in),
    .Sum(Sum),
    .C_out(C_out)
  );

  initial begin
    // Test case 1
    A = 4'b0011;  // 3
    B = 4'b0001;  // 1
    C_in = 0;
    #10;
    
    // Test case 2
    A = 4'b1110;  // 14
    B = 4'b0001;  // 1
    C_in = 0;
    #10;

    // Test case 3
    A = 4'b1111;  // 15
    B = 4'b0001;  // 1
    C_in = 0;
    #10;

    // Test case 4
    A = 4'b0111;  // 7
    B = 4'b1001;  // 9
    C_in = 1;     // Carry in
    #10;

    $finish;
  end

  initial begin
    $dumpfile("tb_adder_4b_result.vcd");
    $dumpvars(0, tb_adder_4b);
    //$monitor("A = %b, B = %b, C_in = %b | Sum = %b, C_out = %b", A, B, C_in, Sum, C_out);
  end
endmodule

module tb_MIPSALU;
  
  // Declaración de las señales
  reg [3:0] ALUctl;   // Señal de control de la ALU (4 bits)
  reg [31:0] A, B;    // Entradas de la ALU (32 bits)
  wire [31:0] ALUOut; // Salida de la ALU (32 bits)
  wire Zero;          // Señal 'Zero' que indica si el resultado es cero

  // Instanciación del módulo MIPSALU
  MIPSALU uut (
    .ALUctl(ALUctl),
    .A(A),
    .B(B),
    .ALUOut(ALUOut),
    .Zero(Zero)
  );

  // Bloque inicial para definir las pruebas
  initial begin
    // Test case 1: Operación AND (ALUctl = 0)
    A = 32'h0000000F;  // A = 15
    B = 32'h00000003;  // B = 3
    ALUctl = 4'b0000;  // AND
    #10;
    
    // Test case 2: Operación OR (ALUctl = 1)
    A = 32'h0000000F;  // A = 15
    B = 32'h00000003;  // B = 3
    ALUctl = 4'b0001;  // OR
    #10;
    
    // Test case 3: Suma (ALUctl = 2)
    A = 32'h0000000F;  // A = 15
    B = 32'h00000001;  // B = 1
    ALUctl = 4'b0010;  // Suma
    #10;
    
    // Test case 4: Resta (ALUctl = 6)
    A = 32'h0000000F;  // A = 15
    B = 32'h00000001;  // B = 1
    ALUctl = 4'b0110;  // Resta
    #10;
    
    // Test case 5: Comparación (A < B) (ALUctl = 7)
    A = 32'h00000003;  // A = 3
    B = 32'h0000000F;  // B = 15
    ALUctl = 4'b0111;  // A < B
    #10;
    
    // Test case 6: Operación NOR (ALUctl = 12)
    A = 32'h0000000F;  // A = 15
    B = 32'h00000003;  // B = 3
    ALUctl = 4'b1100;  // NOR
    #10;

    // Finalizar la simulación
    $finish;
  end

  // Bloque para generar el archivo de volcado de la simulación
  initial begin
    $dumpfile("tb_MIPSALU_result.vcd");
    $dumpvars(0, tb_MIPSALU);
  end

endmodule

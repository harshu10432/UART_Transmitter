module uart (
  input wire clk,
  input wire reset,
  input wire [7:0] data_in,
  input wire start,
  input wire stop,
  output reg tx
);

  reg [3:0] count;
  reg [9:0] shift_reg;
  reg [10:0] bit_count;

  always @(posedge clk or posedge reset) begin
    if (reset)
      count <= 4'b0;
    else begin
      if (start) begin
        count <= 4'b0001;
        shift_reg <= {1'b0, data_in, 1'b1};
        bit_count <= 11'b0;
      end
      else if (count != 4'b0) begin
        if (bit_count < 11)
          tx <= shift_reg[bit_count];
        else
          tx <= 1'b1;

        if (count == 4'b1000)
          count <= 4'b0;
        else
          count <= count + 1;

        if (count == 4'b1000)
          bit_count <= bit_count + 1;
      end
    end
  end

endmodule

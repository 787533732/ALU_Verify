module dut
(  
   input    wire           clk      ,
   input    wire           rst_n    ,

   input    wire [ 3:0]    op_type  ,  
   input    wire [31:0]    src_0    , 
   input    wire [31:0]    src_1    , 
   input    wire           valid_i  ,

   output   reg  [31:0]    sum      ,
   output   reg            taken    ,
   output   reg            valid_o  
);

wire [31:0] v1;
wire [31:0] v2;
assign v1 = src_0 - src_1;
assign v2 = src_1 - src_0;
always @(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
      sum <= 32'd0;
      taken <= 1'b0;
      valid_o <= 1'b0;
   end
   else if(valid_i)begin
      case (op_type)
         4'b0000 : begin//add
            sum     <= src_0 + src_1;
            valid_o <= 1'b1;
         end 
         4'b0001 : begin//sub
            sum     <= src_0 - src_1;
            valid_o <= 1'b1;
         end
         4'b0010 : begin//sll
            sum     <= src_0 << src_1[4:0];
            valid_o <= 1'b1;
         end
         4'b0011 : begin//slt
            sum     <= (src_0[31] ^ src_1[31]) ? src_0[31]: src_0 < src_1;
            valid_o <= 1'b1;
         end
         4'b0100 : begin//sltu
            sum     <= src_0 < src_1;
            valid_o <= 1'b1;
         end
         4'b0101 : begin//xor
            sum     <= src_0  ^ src_1;
            valid_o <= 1'b1;
         end
         4'b0110 : begin//srl
            sum     <= src_0 >> src_1[4:0];
            valid_o <= 1'b1;
         end
         4'b0111 : begin//sra
            sum     <= $signed(src_0) >>> src_1[4:0];
            valid_o <= 1'b1;
         end
         4'b1000 : begin//or
            sum     <= src_0 | src_1;
            valid_o <= 1'b1;
         end
         4'b1001 : begin//and
            sum     <= src_0 & src_1;
            valid_o <= 1'b1;
         end
         4'b1010 : begin//beq
            taken   <= (src_0 == src_1) ? 1'b1 : 1'b0;
            valid_o <= 1'b1;
         end
         4'b1011 : begin//bne
            taken   <= (src_0 != src_1) ? 1'b1 : 1'b0;
            valid_o <= 1'b1;
         end
         4'b1100 : begin//blt
            taken   <= (src_0[31] != src_1[31]) ? src_0[31] : v1[31];
            valid_o <= 1'b1;
         end
         4'b1101 : begin//bge
            taken   <= (src_0[31] != src_1[31]) ? src_1[31] : v2[31] | (src_0==src_1);
            valid_o <= 1'b1;
         end
         4'b1110 : begin//bltu
            taken   <= (src_0 < src_1) ? 1'b1 : 1'b0;
            valid_o <= 1'b1;
         end
         4'b1111 : begin//bgeu
            taken   <= (src_0 >= src_1) ? 1'b1 : 1'b0;
            valid_o <= 1'b1;
         end       
      endcase
   end
   else begin
      sum <= 32'd0;
      taken <= 1'b0;
      valid_o <= 1'b0;
   end
end


endmodule


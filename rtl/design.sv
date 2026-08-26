`timescale 1ns/1ps

module digital_voting_machine #(
    parameter DEBOUNCE_COUNT = 3
)(
    input  logic       clk,
    input  logic       reset,

    input  logic       vote_c1,
    input  logic       vote_c2,
    input  logic       vote_c3,
    input  logic       vote_c4,

    input  logic       show_result,

    output logic [7:0] count_c1,
    output logic [7:0] count_c2,
    output logic [7:0] count_c3,
    output logic [7:0] count_c4,

    output logic [3:0] selected_candidate,
    output logic [6:0] seven_seg
);

    logic [7:0] eeprom [0:3];

    typedef enum logic [2:0] {
        IDLE,
        CHECK,
        STORE,
        WAIT_RELEASE,
        RESULT
    } state_t;

    state_t state;

    logic [1:0] candidate;

    logic [2:0] debounce_counter;

    function automatic [6:0] seven_segment(input [3:0] digit);
        begin
            case (digit)
                4'd0: seven_segment = 7'b1111110;
                4'd1: seven_segment = 7'b0110000;
                4'd2: seven_segment = 7'b1101101;
                4'd3: seven_segment = 7'b1111001;
                4'd4: seven_segment = 7'b0110011;
                4'd5: seven_segment = 7'b1011011;
                4'd6: seven_segment = 7'b1011111;
                4'd7: seven_segment = 7'b1110000;
                4'd8: seven_segment = 7'b1111111;
                4'd9: seven_segment = 7'b1111011;
                default: seven_segment = 7'b0000000;
            endcase
        end
    endfunction

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            state <= IDLE;

            count_c1 <= 0;
            count_c2 <= 0;
            count_c3 <= 0;
            count_c4 <= 0;

            eeprom[0] <= 0;
            eeprom[1] <= 0;
            eeprom[2] <= 0;
            eeprom[3] <= 0;

            candidate <= 0;
            selected_candidate <= 0;
            debounce_counter <= 0;
        end

        else begin
            case (state)

                IDLE: begin
                    if (vote_c1 || vote_c2 || vote_c3 || vote_c4) begin
                        state <= CHECK;
                        debounce_counter <= 0;
                    end

                    else if (show_result) begin
                        state <= RESULT;
                    end
                end

                CHECK: begin
                    if (debounce_counter < DEBOUNCE_COUNT) begin
                        debounce_counter <= debounce_counter + 1;
                    end

                    else begin
                        if (vote_c1)
                            candidate <= 2'd0;

                        else if (vote_c2)
                            candidate <= 2'd1;

                        else if (vote_c3)
                            candidate <= 2'd2;

                        else if (vote_c4)
                            candidate <= 2'd3;

                        state <= STORE;
                        debounce_counter <= 0;
                    end
                end

                STORE: begin
                    case (candidate)

                        2'd0: begin
                            count_c1 <= count_c1 + 1;
                            eeprom[0] <= count_c1 + 1;
                            selected_candidate <= 4'd1;
                        end

                        2'd1: begin
                            count_c2 <= count_c2 + 1;
                            eeprom[1] <= count_c2 + 1;
                            selected_candidate <= 4'd2;
                        end

                        2'd2: begin
                            count_c3 <= count_c3 + 1;
                            eeprom[2] <= count_c3 + 1;
                            selected_candidate <= 4'd3;
                        end

                        2'd3: begin
                            count_c4 <= count_c4 + 1;
                            eeprom[3] <= count_c4 + 1;
                            selected_candidate <= 4'd4;
                        end

                    endcase

                    state <= WAIT_RELEASE;
                end

                WAIT_RELEASE: begin
                    if (!(vote_c1 || vote_c2 || vote_c3 || vote_c4))
                        state <= IDLE;
                end

                RESULT: begin
                    if (!show_result)
                        state <= IDLE;
                end

                default:
                    state <= IDLE;

            endcase
        end
    end

    always_comb begin
        if (show_result)
            seven_seg = seven_segment(count_c1[3:0]);
        else
            seven_seg = 7'b0000000;
    end

endmodule

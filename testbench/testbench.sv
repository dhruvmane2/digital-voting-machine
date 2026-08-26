`timescale 1ns/1ps

module testbench;

    logic clk;
    logic reset;

    logic vote_c1;
    logic vote_c2;
    logic vote_c3;
    logic vote_c4;

    logic show_result;

    logic [7:0] count_c1;
    logic [7:0] count_c2;
    logic [7:0] count_c3;
    logic [7:0] count_c4;

    logic [3:0] selected_candidate;
    logic [6:0] seven_seg;

    digital_voting_machine #(
        .DEBOUNCE_COUNT(3)
    ) DUT (
        .clk(clk),
        .reset(reset),

        .vote_c1(vote_c1),
        .vote_c2(vote_c2),
        .vote_c3(vote_c3),
        .vote_c4(vote_c4),

        .show_result(show_result),

        .count_c1(count_c1),
        .count_c2(count_c2),
        .count_c3(count_c3),
        .count_c4(count_c4),

        .selected_candidate(selected_candidate),
        .seven_seg(seven_seg)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task vote_candidate(input integer candidate_number);
        begin
            case (candidate_number)
                1: vote_c1 = 1;
                2: vote_c2 = 1;
                3: vote_c3 = 1;
                4: vote_c4 = 1;
            endcase

            repeat (6) @(posedge clk);

            vote_c1 = 0;
            vote_c2 = 0;
            vote_c3 = 0;
            vote_c4 = 0;

            repeat (3) @(posedge clk);
        end
    endtask

    initial begin

        reset = 1;

        vote_c1 = 0;
        vote_c2 = 0;
        vote_c3 = 0;
        vote_c4 = 0;

        show_result = 0;

        repeat (3) @(posedge clk);
        reset = 0;

        $display("------------------------------------");
        $display(" DIGITAL VOTING MACHINE TEST");
        $display("------------------------------------");

        vote_candidate(1);
        vote_candidate(1);

        vote_candidate(2);
        vote_candidate(2);
        vote_candidate(2);

        vote_candidate(3);

        vote_candidate(4);
        vote_candidate(4);

        @(posedge clk);

        $display("");
        $display("========== FINAL RESULTS ==========");
        $display("Candidate 1 = %0d votes", count_c1);
        $display("Candidate 2 = %0d votes", count_c2);
        $display("Candidate 3 = %0d votes", count_c3);
        $display("Candidate 4 = %0d votes", count_c4);
        $display("===================================");
        $display("");

        show_result = 1;

        repeat (3) @(posedge clk);

        $display("7-Segment output = %b", seven_seg);

        show_result = 0;

        #20;

        $finish;

    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end

endmodule

# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
import random
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 104

    # Wait for one clock cycle to see the output values
    await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    assert dut.uo_out.value == 48

    for num_one in range (0, 16):
        for num_two in range (0, 16):
            target = num_one * num_two

            str_binary = "0b" + bin(num_one)[2:].zfill(4) + bin(num_two)[2:].zfill(4)

            num_binary = int(str_binary, 2)
            print("1: " + str(num_one) + ", 2: " + str(num_two) + " => bin: " + str_binary + " or " + str(num_binary))
            print("Target: " + str(target))

            dut.ui_in.value = num_binary

            await ClockCycles(dut.clk, 1)

            print("Received: " + str(dut.uo_out.value))

            assert dut.uo_out.value == target

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.

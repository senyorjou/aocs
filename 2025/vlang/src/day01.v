module main

import os
import regex
import strconv
import math // Import math module for abs

struct Instruction {
	letter string
	number int
}

fn parse_data() ![]Instruction {
	// Changed to use data/day01/input.txt for consistency
	day1_data := os.read_file('data/day-01-input.txt') or {
		eprintln('Failed to read data/day-01-input.txt: ${err}')
		return error('Failed to read data/day-01-input.txt: ${err}') // Return error from Result type
	}

	mut instructions := []Instruction{}
	pattern := r'([LR])(\d+)'

	mut re := regex.new()
	re.compile_opt(pattern) or {
		eprintln('Error creating regex: ${err}')
		return error('Error creating regex: ${err}') // Return error from Result type
	}

	for line in day1_data.split_into_lines() {
		if line.len == 0 {
			continue
		}

		start, _ := re.match_string(line)
		if start == -1 {
			eprintln('No match found for line: "${line}"')
			continue
		}

		letter := re.get_group_by_id(line, 0)
		number_str := re.get_group_by_id(line, 1)

		number := strconv.atoi(number_str) or {
			eprintln('Failed to convert number string "${number_str}" to int: ${err}')
			return error('Failed to convert number string "${number_str}" to int: ${err}') // Return error from Result type
		}

		instructions << Instruction{
			letter: letter
			number: number
		}
	}
	return instructions
}

// Helper function for floor division, as V's / truncates towards zero
fn floor_div(a int, b int) int {
    mut res := a / b // Corrected: declared as mutable
    if a < 0 && a % b != 0 { // Corrected: removed unnecessary parentheses
        res--
    }
    return res
}

fn count_zeroes(instructions []Instruction) int {
	mut pos := 50
	mut zeroes := 0
	for instruction in instructions {
		if instruction.letter == 'L' {
			pos -= instruction.number
		} else {
			pos += instruction.number
		}

		if pos % 100 == 0 {
			zeroes++
		}
	}

	return zeroes
}

fn count_passes(instructions []Instruction) int {
	mut pos := 50
	mut passes := 0
	mut prev_segment := floor_div(pos, 100)

	for instruction in instructions {
		if instruction.letter == 'L' {
			pos -= instruction.number
		} else {
			pos += instruction.number
		}

		new_segment := floor_div(pos, 100)

		if new_segment != prev_segment {
			passes += math.abs(new_segment - prev_segment)
		}
		prev_segment = new_segment
	}

	return passes
}

fn run_day01() ! { // Corrected: function now returns a Result type
	instructions := parse_data()!

	println('Advent of Code 2025 - Day 01')

	println('P1: ${count_zeroes(instructions)}')
	println('P2: ${count_passes(instructions)}')
}


fn main() {
	run_day01() or {
		eprintln('Error running Day 01: ${err}') // Handle error from run_day01
	}
}

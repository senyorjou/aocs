module main

import os

fn test_day01_data_exists() {
	assert os.exists('data/day01/input.txt')
}

fn test_placeholder() {
	assert 1 + 1 == 2
}

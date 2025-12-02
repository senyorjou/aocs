# AGENT Guidelines for Advent of Code 2025 (VLang)

This document provides guidelines and information for AI agents working on the Advent of Code 2025 solutions in VLang.

## Project Overview

This project is dedicated to solving the Advent of Code 2025 challenges using the V programming language. Each day's solution should be self-contained and leverage the provided data structure.

## Project Structure

- `src/`: Contains VLang source files. `main.v` is the primary entry point.
- `data/`: Stores input data for each day. A day may have a `day-xx-sample.txt` and a `day-xx-input.txt`
- `tests/`: Contains unit tests for the solutions.
- `v.mod`: VLang project configuration file.
- `README.md`: General project overview.
- `AGENTS.md`: This document.

## Key Files & Their Purpose

- `v.mod`: Defines project metadata (name, version, description, license) and dependencies.
- `src/main.v`: The main application logic. It should load data and call functions for each day's solution.
- `tests/main_test.v`: Contains test cases. New tests for each day's solution should be added here or in separate `_test.v` files within the `tests/` directory.

## Core Commands

- **Build:** `v build src` - Compiles the project.
- **Run:** `v run src` - Executes the main application.
- **Test:** `v test tests` - Runs all tests in the `tests/` directory.

## Data Handling

Input data for each day is located in `data/day-XX-sample.txt` and `data/day-XX-input.txt` (where `XX` is the day number, e.g., `01`, `02`). Ensure your solutions read data from these paths.

## Conventions and Guidelines for Agents

1.  **VLang Idioms:** Adhere to VLang's official style guide and common idioms.
2.  **Modularity:** For each day, consider creating a separate V module or well-defined functions within `src/main.v` or a new file like `src/day01.v` to keep solutions organized.
3.  **Testing:**
    - Always write unit tests for your solutions.
    - Place tests in the `tests/` directory.
    - Use the `v test tests` command to verify your changes.
    - Use sample data (e.g., in `data/dayXX/sample.txt`) for testing, and actual input data for final verification.
4.  **Error Handling:** Implement robust error handling, especially when reading files or parsing data.
5.  **Performance:** Advent of Code problems often have performance constraints. Keep efficiency in mind when designing algorithms.
6.  **Comments:** Add comments sparingly, focusing on complex logic or design decisions (the "why"), rather than obvious code.
7.  **Dependencies:** Avoid adding external dependencies unless absolutely necessary and approved by the user. Prefer V's standard library.

Feel free to ask for clarification if any part of these guidelines is unclear or if you need to propose a deviation for a specific reason.

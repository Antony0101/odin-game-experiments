package main

import "core:fmt"
foreign import ncurses "system:ncurses"


@(default_calling_convention = "c")
foreign ncurses {
	initscr :: proc() -> rawptr ---
	endwin :: proc() -> int ---
	clear :: proc() -> int ---
	refresh :: proc() -> int ---
	getch :: proc() -> int ---
	keypad :: proc(win: rawptr, enabled: bool) -> int ---
	noecho :: proc() -> int ---
	cbreak :: proc() -> int ---
	mvprintw :: proc(y, x: int, fmt: cstring, #c_vararg args: ..any) -> int ---

	stdscr: rawptr
}

KEY_UP :: 259
KEY_DOWN :: 258
KEY_ENTER :: 10

main :: proc() {
	initscr()
	// defer endwin()

	cbreak()
	noecho()
	keypad(stdscr, true)

	options := [3]string{"New Game", "Load Game", "Quit"}

	selected := 0
	is_loop := true
	for is_loop {
		clear()

		mvprintw(1, 2, "Select an option:")
		mvprintw(2, 2, "(Arrow keys + Enter or press 1-3)")

		for i in 0 ..< len(options) {
			if i == selected {
				mvprintw(4 + i, 2, "> %d. %s", i + 1, options[i])
			} else {
				mvprintw(4 + i, 2, "  %d. %s", i + 1, options[i])
			}
		}

		refresh()

		ch := getch()

		switch ch {
		case KEY_UP:
			if selected > 0 {
				selected -= 1
			}

		case KEY_DOWN:
			if selected < len(options) - 1 {
				selected += 1
			}

		case KEY_ENTER:
			is_loop = false
			break

		case int('1'):
			selected = 0
			is_loop = false

		case int('2'):
			selected = 1
			is_loop = false

		case int('3'):
			selected = 2
			is_loop = false
		}
	}
	endwin()

	// ncurses screen is closed here because of defer

	switch selected {
	case 0:
		fmt.println("New Game selected")
	case 1:
		fmt.println("Load Game selected")
	case 2:
		fmt.println("Quit selected")
	}
}

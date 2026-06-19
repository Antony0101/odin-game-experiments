package main

import "core:fmt"
import "core:mem"
import "core:strconv"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

// ValueType :: enum {
// 	number,
// 	colour,
// 	string,
// }

Parsed_Class :: struct {
	// [0] - elem state, [1] - screen state, [2]-theme state
	variants:  [3]string,
	utility:   string,
	value:     string,
	// valueType: ValueType,
	arbitrary: bool,
}


elem_states := [?]string{"hover", "focus", "active"}
screen_states := [?]string{"sm", "md", "lg", "xl", "2xl"}
theme_states := [?]string{"light", "dark", "custom"}

utilities := [?]string {
	// padding
	"p",
	"px",
	"py",
	"pt",
	"pl",
	"pb",
	"pr",
	// margin
	"m",
	"mx",
	"my",
	"mt",
	"ml",
	"mb",
	"mr",
	// width and height
	"h",
	"w",
	// others
	"text",
	"bg",
	"border",
}

Style_State :: enum {
	default = 0,
	hover   = 1,
	focus   = 2,
	active  = 3,
}

Style_Struct :: struct {
	pt:           Maybe(f32),
	pb:           Maybe(f32),
	pl:           Maybe(f32),
	pr:           Maybe(f32),
	mt:           Maybe(f32),
	mb:           Maybe(f32),
	ml:           Maybe(f32),
	mr:           Maybe(f32),
	h:            Maybe(f32),
	w:            Maybe(f32),
	bg_color:     Maybe(rl.Color),
	text_color:   Maybe(rl.Color),
	text_size:    Maybe(f32),
	border_color: Maybe(rl.Color),
	border_width: Maybe(f32),
}

Style_Param :: [4]Style_Struct

hex_or_str_to_color :: proc(hex: string) -> (rl.Color, bool) {
	if (hex == "white") {
		return rl.WHITE, true
	}
	if (hex == "black") {
		return rl.BLACK, true
	}
	if (hex == "red") {
		return rl.RED, true
	}
	if (hex == "green") {
		return rl.GREEN, true
	}
	if (hex == "blue") {
		return rl.BLUE, true
	}
	if (hex == "yellow") {
		return rl.YELLOW, true
	}
	if len(hex) != 7 || hex[0] != '#' {
		return {}, false
	}

	r64, ok1 := strconv.parse_uint(hex[1:3], 16)
	g64, ok2 := strconv.parse_uint(hex[3:5], 16)
	b64, ok3 := strconv.parse_uint(hex[5:7], 16)

	if !ok1 || !ok2 || !ok3 {
		return {}, false
	}

	return rl.Color{u8(r64), u8(g64), u8(b64), 255}, true
}

parse_class :: proc(token: string) -> Parsed_Class {
	result: Parsed_Class

	parts := strings.split(token, ":")
	// defer delete(parts)

	// currently only taking first part
	if len(parts) > 1 {
		// result.variants[0] = parts[0]
		for part in parts {
			for elem_s in elem_states {
				if part == elem_s {
					result.variants[0] = part
				}
			}
			for screen_s in screen_states {
				if part == screen_s {
					result.variants[1] = part
				}
			}
			for theme_s in theme_states {
				if part == theme_s {
					result.variants[1] = part
				}
			}
		}
		// result.variants[0] = parts[0]
	}

	utility_part := parts[len(parts) - 1]

	bracket_start := strings.index(utility_part, "-[")
	if bracket_start >= 0 {
		result.utility = utility_part[:bracket_start]

		value_start := bracket_start + 2
		value_end := len(utility_part) - 1

		result.value = utility_part[value_start:value_end]
		result.arbitrary = true

		return result
	}

	dash := strings.index(utility_part, "-")

	if dash < 0 {
		result.utility = utility_part
		return result
	}

	result.utility = utility_part[:dash]
	result.value = utility_part[dash + 1:]

	return result
}

parse_style_string :: proc(input: string) -> []Parsed_Class {
	tokens := strings.fields(input)
	defer delete(tokens)

	result := make([]Parsed_Class, len(tokens))

	for token, index in tokens {
		parsed := parse_class(token)
		result[index] = parsed
	}
	return result
}

generate_style_struct :: proc(
	input: []Parsed_Class,
	ishover: bool,
	isfocus: bool,
	isactive: bool,
) -> ^Style_Struct {

	result := new(Style_Struct)

	for parsed, index in input {
		if parsed.variants[0] == "hover" && !ishover do continue
		if parsed.variants[0] == "active" && !isactive do continue
		if parsed.variants[0] == "focus" && !isfocus do continue
		val_num, ok_num := strconv.parse_f32(parsed.value)
		val_color, ok_color := hex_or_str_to_color(parsed.value)
		switch parsed.utility {
		case "pt":
			assert(ok_num)
			result.pt = val_num
		case "pb":
			assert(ok_num)
			result.pb = val_num
		case "pl":
			assert(ok_num)
			result.pl = val_num
		case "pr":
			assert(ok_num)
			result.pr = val_num
		case "px":
			assert(ok_num)
			result.pr = val_num
			result.pl = val_num
		case "py":
			assert(ok_num)
			result.pt = val_num
			result.pb = val_num
		case "p":
			assert(ok_num)
			result.pr = val_num
			result.pl = val_num
			result.pt = val_num
			result.pb = val_num
		case "mt":
			assert(ok_num)
			result.mt = val_num
		case "mb":
			assert(ok_num)
			result.mb = val_num
		case "ml":
			assert(ok_num)
			result.ml = val_num
		case "mr":
			assert(ok_num)
			result.mr = val_num
		case "mx":
			assert(ok_num)
			result.mr = val_num
			result.ml = val_num
		case "my":
			assert(ok_num)
			result.mt = val_num
			result.mb = val_num
		case "m":
			assert(ok_num)
			result.mr = val_num
			result.ml = val_num
			result.mt = val_num
			result.mb = val_num
		case "text":
			assert(ok_num || ok_color)
			if ok_num do result.text_size = val_num
			else do result.text_color = val_color
		case "bg":
			assert(ok_color)
			result.bg_color = val_color
		case "border":
			assert(ok_num || ok_color)
			if ok_num do result.border_width = val_num
			else do result.border_color = val_color
		}

	}
	return result
}


main :: proc() {
	// 1. Initialize the tracking allocator wrapper over the default allocator
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)

	// 2. Assign it to the current context so all allocations go through it
	context.allocator = mem.tracking_allocator(&track)

	start := time.now()
	input := "bg-red-500 p-4 hover:bg-blue-500 md:hover:flex w-[100px] bg-[#ff0000]"
	classes := parse_style_string(input)
	defer delete(classes)
	endTime := time.since(start)
	fmt.println("--------------")
	fmt.println("time elasped:", endTime)

	// 3. Inspect your program's active memory metrics
	fmt.printf("Total memory allocated so far: %v bytes\n", track.total_memory_allocated)
	fmt.printf("Current memory active (RAM used): %v bytes\n", track.current_memory_allocated)
	fmt.printf("Total allocation operations: %v\n", track.total_allocation_count)

	// for class in classes {
	// 	fmt.println("----------------")

	// 	fmt.println("utility:", class.utility)
	// 	fmt.println("value:", class.value)
	// 	fmt.println("arbitrary:", class.arbitrary)

	// 	if len(class.variants) > 0 {
	// 		fmt.print("variants: ")

	// 		for v in class.variants {
	// 			fmt.print(v, " ")
	// 		}

	// 		fmt.println()
	// 	}
	// }
}

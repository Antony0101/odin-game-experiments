package main

import "core:testing"
import rl "vendor:raylib"


@(test)
test_class_parser_single_class_without_varients :: proc(t: ^testing.T) {
	// single class
	str := "p-10"
	result := parse_class(str)
	testing.expect(t, result.utility == "p", "expect utility to be p")
	testing.expect(t, result.arbitrary == false, "expect arbitrary to be false")
	testing.expect(t, result.value == "10", "expect value to be str 10")
	testing.expect(t, result.variants[0] == "", "expect varient at index 0 to be empty")
	testing.expect(t, result.variants[1] == "", "expect varient at index 1 to be empty")
	testing.expect(t, result.variants[2] == "", "expect varient at index 2 to be empty")
}

@(test)
test_class_parser_single_class_with_varient_elem_state :: proc(t: ^testing.T) {
	// single class
	str := "hover:h-[10]"
	result := parse_class(str)
	testing.expect(t, result.utility == "h", "expect utility to be p")
	testing.expect(t, result.arbitrary == true, "expect arbitrary to be false")
	testing.expect(t, result.value == "10", "expect value to be str 10")
	testing.expect(t, result.variants[0] == "hover", "expect varient at index 0 to be hover")
	testing.expect(t, result.variants[1] == "", "expect varient at index 1 to be empty")
	testing.expect(t, result.variants[2] == "", "expect varient at index 2 to be empty")
}
@(test)
test_class_parser_single_class_with_varient_multiple :: proc(t: ^testing.T) {
	// single class
	str := "md:hover:h-[10]"
	result := parse_class(str)
	testing.expect_value(t, result.variants[0], "hover")
	testing.expect_value(t, result.variants[1], "md")
	testing.expect(t, result.variants[2] == "", "expect varient at index 2 to be empty")
}

@(test)
test_hex_color_converter :: proc(t: ^testing.T) {
	// single class
	str := "#ffffff"
	result, ok := hex_or_str_to_color(str)
	testing.expect_value(t, result, rl.WHITE)
	testing.expect_value(t, ok, true)
	str2 := "aabbcc"
	result2, ok2 := hex_or_str_to_color(str2)
	testing.expect(t, ok2 == false, "aabbcc ok should be false")
	str3 := "#aabbcccc"
	result3, ok3 := hex_or_str_to_color(str3)
	testing.expect(t, ok3 == false, "#aabbcccc ok should be false")
}

@(test)
test_style_generator :: proc(t: ^testing.T) {
	// single class
	str := "pr-10 pl-50 hover:pl-10"
	style_list := parse_style_string(str)
	defer delete(style_list)
	st := generate_style_struct(style_list, true, false, false)
	testing.expect_value(t, st.pl, 10)
}

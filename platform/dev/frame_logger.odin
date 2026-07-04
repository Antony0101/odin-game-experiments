package platform_dev

import "../../shared"
import "core:fmt"
import "core:os"

MAX_LOGS :: 200
MAX_LOG_LENGTH :: 512

Log_Entry :: struct {
	frame:  u64,
	level:  shared.Log_Level,
	length: int,
	text:   [MAX_LOG_LENGTH]u8,
}

Logger :: struct {
	entries: [MAX_LOGS]Log_Entry,
	head:    int, // Next slot to write
	count:   int, // Number of valid entries
}

default_logger: Logger

frame_logger_setup :: proc(fileName: string) -> ^os.File {
	errdir := os.make_directory_all("./logs")
	if errdir != nil && errdir != .Exist {
		panic("logs directory creation failed")
	}
	file, err := os.create(fileName)
	if err != nil {
		panic("logger file creation failed")
	}
	return file
}

frame_log :: proc(frame: u64, level: shared.Log_Level, msg: string) {
	logger := &default_logger
	entry := &logger.entries[logger.head]

	entry.frame = frame
	entry.level = level

	n := min(len(msg), MAX_LOG_LENGTH - 1)

	copy(entry.text[:], msg[:n])
	entry.text[n] = 0
	entry.length = n

	logger.head = (logger.head + 1) % MAX_LOGS

	if logger.count < MAX_LOGS {
		logger.count += 1
	}
}

frame_logf :: proc(frame: u64, level: shared.Log_Level, fmt_string: string, args: ..any) {
	logger := &default_logger
	entry := &logger.entries[logger.head]

	entry.frame = frame
	entry.level = level

	// Format directly into entry.text
	n := fmt.bprintf(entry.text[:], fmt_string, ..args)

	entry.length = len(n)

	logger.head = (logger.head + 1) % MAX_LOGS

	if logger.count < MAX_LOGS {
		logger.count += 1
	}
}


frame_dump :: proc() {
	logger := default_logger
	start := (logger.head - logger.count + MAX_LOGS) % MAX_LOGS

	for i in 0 ..< logger.count {
		index := (start + i) % MAX_LOGS

		entry := logger.entries[index]

		fmt.printf("[%8d][%v] %.*s\n", entry.frame, entry.level, entry.length, entry.text[:])
	}
}

frame_dump_to_file :: proc(file: ^os.File) {
	logger := default_logger
	start := (logger.head - logger.count + MAX_LOGS) % MAX_LOGS

	for i in 0 ..< logger.count {
		index := (start + i) % MAX_LOGS

		entry := logger.entries[index]

		fmt.fprintf(
			file,
			"[%8d][%v] %s\n",
			entry.frame,
			entry.level,
			// entry.length,
			entry.text[:entry.length],
		)
	}
	os.close(file)
}

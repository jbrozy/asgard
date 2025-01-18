package logger

import "core:time"

Level :: enum {
	DEBUG,
	INFO,
	SEVERE,
}

Entry :: struct {
	timestamp: time.Time,
	level:     Level,
}

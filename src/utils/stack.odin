package utils

Stack :: proc($T: typeid) {
	data: []T
	length: i32 = 0
}

push :: proc($N: $I, $T: typeid) {
}

pop :: proc() -> $T {
	if length == 0 {
		return nil
	}
	item = data[length]
	length = length - 1
	return item
}

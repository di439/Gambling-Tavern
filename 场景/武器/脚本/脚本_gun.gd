class_name Gun  extends RefCounted

enum ShellType { LIVE, BLANK }

var shells: Array[ShellType] = []
var index := 0

func load_random(live_count: int, blank_count: int) -> void:
	var arr: Array[ShellType] = []
	for i in live_count:
		arr.append(ShellType.LIVE)
	for i in blank_count:
		arr.append(ShellType.BLANK)
	arr.shuffle()
	shells = arr
	index = 0

func shoot() -> ShellType:
	if is_empty():
		return ShellType.BLANK
	var s := shells[index]
	index += 1
	return s

func is_empty() -> bool:
	return index >= shells.size()

func remaining() -> int:
	return shells.size() - index

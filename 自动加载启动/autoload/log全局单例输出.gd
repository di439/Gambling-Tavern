extends Node

signal message_added(text: String)

func print_line(...args) -> void:
	var text := ""
	for i in args.size():
		if i > 0:
			text += " "
		text += str(args[i])
	print(text)
	message_added.emit(text)

extends Control

signal level_chosen(level_id: StringName)

func _ready() -> void:
	visible = false
	$选关/level1.pressed.connect(_on_level1_pressed)

func _on_level1_pressed() -> void:
	hide()
	level_chosen.emit("level_01")

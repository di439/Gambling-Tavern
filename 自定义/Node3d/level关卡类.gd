class_name Level
extends Node3D

## 关卡标识名
@export var id_name: StringName = ""

## 玩家出生点
@export var birth_point: Marker3D

## 玩家场景（预加载或导出）
@export var player_scene: PackedScene


func _ready() -> void:
	if birth_point == null:
		push_error("Level 没设置出生点")
		return
	if player_scene == null:
		push_error("Level 没设置玩家场景")
		return
	
	var p := player_scene.instantiate()
	add_child(p)
	p.global_position = birth_point.global_position
	p.global_rotation = birth_point.global_rotation

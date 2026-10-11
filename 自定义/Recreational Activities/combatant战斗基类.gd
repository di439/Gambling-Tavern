class_name Combatant  extends CharacterBody3D

signal damaged(amount: int, current_hp: int)
signal died()

@export var max_hp := 3
var hp := 3
var gun: Gun = null

func _ready() -> void:
	hp = max_hp

func is_dead() -> bool:
	return hp <= 0

func take_damage(amount: int) -> void:
	if is_dead():
		return
	hp -= amount
	hp = max(0, hp)
	damaged.emit(amount, hp)
	if is_dead():
		die()

func die() -> void:
	died.emit()
	# 子类重写做具体处理（比如播放死亡动画）

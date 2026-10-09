@icon("res://资产库/节点图标/icon_state.png")
class_name MoveState  extends State

func _enter() -> void:
	print("进入移动状态")

func _physics_running(delta: float) -> void:
	user.do_move(delta)

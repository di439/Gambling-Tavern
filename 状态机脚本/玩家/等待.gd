@icon("res://资产库/节点图标/icon_state.png")
class_name WaitState  extends State

func _enter() -> void:
	Log.print_line("等待敌人回合")
	user.velocity = Vector3.ZERO

func _physics_running(delta: float) -> void:
	user.apply_gravity(delta)
	user.move_and_slide()

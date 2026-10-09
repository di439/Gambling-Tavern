@icon("res://资产库/节点图标/icon_state.png")
class_name PlayState  extends State

func _enter() -> void:
	print("进入轮盘赌状态")
	user.velocity = Vector3.ZERO          # 停下

func _physics_running(delta: float) -> void:
	# 只做重力，不移动
	user.apply_gravity(delta)
	user.move_and_slide()

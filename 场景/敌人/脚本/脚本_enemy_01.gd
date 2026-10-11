class_name Enemy  extends Combatant

@export var think_time := 1.0        # 思考时间（秒）

var game_flow: GameFlow = null

func _ready() -> void:
	hp = max_hp

## 由 GameFlow 在敌人回合开始时调用
func take_turn() -> void:
	await get_tree().create_timer(think_time).timeout
	
	if is_dead():
		return
	
	if gun == null or gun.is_empty():
		Log.print_line("敌人没枪或没子弹，跳过")
		_end_turn()
		return
	
	# 随机选目标
	var self_target := randf() < 0.5
	var shell = gun.shoot()
	
	if shell == Gun.ShellType.LIVE:
		if self_target:
			take_damage(1)
		else:
			_attack_player()
		_end_turn()
	else:
		# 空弹保留回合，递归再开一枪
		Log.print_line("敌人打出空弹，继续")
		take_turn()

func _attack_player() -> void:
	var game_flow = get_tree().get_first_node_in_group("game_flow")
	if game_flow and game_flow.player:
		game_flow.player.take_damage(1)

func _end_turn() -> void:
	var game_flow = get_tree().get_first_node_in_group("game_flow")
	if game_flow:
		game_flow.end_turn()

@icon("res://资产库/节点图标/icon_state.png")
class_name PlayState  extends State

func _enter() -> void:
	Log.print_line("玩家回合")
	user.velocity = Vector3.ZERO
	
	if user.gun == null and Loadout.selected_weapon:
		user.gun = Gun.new()
		user.gun.load_random(
			Loadout.selected_weapon.live_shells,
			Loadout.selected_weapon.blank_shells
		)
		Log.print_line("装备：%s" % Loadout.selected_weapon.weapon_name)

func _physics_running(delta: float) -> void:
	# 只做重力，不移动
	user.apply_gravity(delta)
	user.move_and_slide()
	
	# 开枪输入
	if Input.is_action_just_pressed("use"):
		_shoot(false)      # 打敌人
	elif Input.is_action_just_pressed("shoot_self"):
		_shoot(true)       # 打自己

func _exit() -> void:
	pass

## 开枪
func _shoot(self_target: bool) -> void:
	Log.print_line("===== 开枪 =====")
	Log.print_line("目标自己？%s" % self_target)
	Log.print_line("user.gun = %s" % str(user.gun))
	
	if user.gun == null:
		Log.print_line("没枪")
		_end_turn()
		return
	if user.gun.is_empty():
		Log.print_line("枪里没子弹")
		_end_turn()
		return
	
	var shell = user.gun.shoot()
	Log.print_line("打出：%s" % shell)     # 👈 关键，看打的是什么
	
	if shell == Gun.ShellType.LIVE:
		Log.print_line("★ 实弹！")
		if self_target:
			user.take_damage(1)
			Log.print_line("自己扣血，HP = %d" % user.hp)
		else:
			var enemy = _get_enemy()
			Log.print_line("敌人 = %s" % str(enemy))
			if enemy:
				enemy.take_damage(1)
				Log.print_line("敌人扣血，HP = %d" % enemy.hp)
		_end_turn()
	else:
		Log.print_line("○ 空弹，继续你的回合")

func _end_turn() -> void:
	var game_flow = get_tree().get_first_node_in_group("game_flow")
	if game_flow:
		game_flow.end_turn()

func _get_enemy() -> Combatant:
	var game_flow = get_tree().get_first_node_in_group("game_flow")
	if game_flow:
		return game_flow.enemy
	return null

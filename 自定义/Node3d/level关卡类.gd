class_name Level  extends Node3D

@export var id_name: StringName = ""
@export var birth_point: Marker3D
@export var player_scene: PackedScene
@export var game_framework: Node3D
@export var enemy_scene: PackedScene
@export var enemy_position: Marker3D

@onready var play_position: Marker3D = game_framework.get_node("玩家/玩家_01")

var player: Player = null          # 👈 类型改成 Player
var enemy: Combatant = null

func _ready() -> void:
	# 只生成玩家、设置 Loadout
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = birth_point.global_position
	player.level_chosen.connect(_on_level_chosen)
	
	Loadout.selected_weapon = preload("res://物体数据/武器/远程武器/Gun.tres")

func _on_level_chosen(level_id: StringName) -> void:
	player.global_position = play_position.global_position
	
	# 生成敌人
	if enemy == null:
		enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.global_position = enemy_position.global_position
		enemy.gun = Gun.new()
		enemy.gun.load_random(3, 2)
	
	# 给玩家发枪
	if player.gun == null:
		player.gun = Gun.new()
		player.gun.load_random(3, 2)
	
	# 把玩家/敌人交给游戏框架
	game_framework.setup(player, enemy)
	
	# 切 play 状态
	player.state_machine.change_state("play")
	
	Log.print_line("进入关卡：%s" % level_id)

extends Node3D

@onready var game_flow: GameFlow = $"回合调度器"
@onready var player_marker: Marker3D = $玩家/玩家_01
@onready var enemy_marker: Marker3D = $敌人/敌人_01

var player: Player = null
var enemy: Combatant = null

func _ready() -> void:
	game_flow.game_over.connect(_on_game_over)

func setup(p: Player, e: Combatant) -> void:
	player = p
	enemy = e
	game_flow.setup(player, enemy)
	game_flow.start()

func _on_game_over(winner) -> void:
	Log.print_line("游戏结束，赢家：%s" % winner)
	if player:
		player.state_machine.change_state("move")
	if enemy:
		enemy.queue_free()
		enemy = null

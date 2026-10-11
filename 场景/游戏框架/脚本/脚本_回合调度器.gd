class_name GameFlow
extends Node

signal turn_changed(new_turn: Turn)
signal game_over(winner: Turn)

enum Turn { PLAYER, ENEMY }

var current_turn: Turn = Turn.PLAYER
var player: Combatant = null
var enemy: Combatant = null

func _ready() -> void:
	add_to_group("game_flow")

func setup(p: Combatant, e: Combatant) -> void:
	player = p
	enemy = e

## 开始游戏（从玩家回合开始）
func start() -> void:
	# 临时：给玩家和敌人各发一把枪
	player.gun = Gun.new()
	player.gun.load_random(3, 2)
	enemy.gun = Gun.new()
	enemy.gun.load_random(3, 2)
	
	current_turn = Turn.PLAYER
	turn_changed.emit(current_turn)

## 结束当前回合，换到对方
func end_turn() -> void:
	if check_game_over():
		return
	
	if current_turn == Turn.PLAYER:
		current_turn = Turn.ENEMY
	else:
		current_turn = Turn.PLAYER
	turn_changed.emit(current_turn)
	
	if current_turn == Turn.ENEMY and enemy:
		enemy.take_turn()

func check_game_over() -> bool:
	if player.is_dead():
		game_over.emit(Turn.ENEMY)
		return true
	if enemy.is_dead():
		game_over.emit(Turn.PLAYER)
		return true
	return false

## 当前是不是玩家回合
func is_player_turn() -> bool:
	return current_turn == Turn.PLAYER

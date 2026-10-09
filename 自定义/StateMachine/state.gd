@icon("res://资产库/节点图标/icon_state.png")
class_name State extends Node

## 状态名（在编辑器里填，或代码里设置）
@export var state_name: StringName = ""

## 调试用，进入/退出时打印
@export var enter_message: String = ""
@export var exit_message: String = ""

## 当前是否处于这个状态
var running := false

## 状态机引用（由父节点注入）
var machine: StateMachine
var user: Node   # 拥有者（比如 Player）

## 判断"能不能进入这个状态"，返回 false 会拒绝切换
func _check() -> bool:
	return true

## 进入状态时调用一次
func _enter() -> void:
	pass

## 离开状态时调用一次
func _exit() -> void:
	pass

## 每帧调用（在状态机 _process 里）
func _running(delta: float) -> void:
	pass

## 每物理帧调用（在状态机 _physics_process 里）
func _physics_running(delta: float) -> void:
	pass

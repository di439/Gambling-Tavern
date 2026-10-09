@icon("res://资产库/节点图标/icon_state_machine.png")
class_name StateMachine  extends Node

signal state_changed(old_state: State, new_state: State)

@export var debug := false ## 是否打印信息
@export var owner_node: Node  ## 状态机内共享数据

var current_state: State:
	set(val):
		if current_state == val:
			return
		if val == null or val.state_name == "":
			push_error("状态为空或状态名为空")
			return
		
		if current_state:
			if debug and current_state.exit_message:
				print(current_state.exit_message)
			current_state.running = false
			current_state._exit()
		
		var old := current_state
		current_state = val
		current_state.running = true
		current_state._enter()
		
		if debug and current_state.enter_message:
			print(current_state.enter_message)
		
		state_changed.emit(old, current_state)

func _ready() -> void:
	# 把 owner 引用塞给每个状态
	for child in get_children():
		if child is State:
			child.machine = self
			child.user = owner_node
	
	# 自动进入第一个状态
	if get_child_count() > 0 and get_child(0) is State:
		change_state(get_child(0).state_name)

func _process(delta: float) -> void:
	if current_state:
		current_state._running(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._physics_running(delta)

## 切换状态（按名字找）
func change_state(name: StringName) -> bool:
	for node in get_children():
		if node is State and node.state_name == name:
			if node._check():
				current_state = node
				return true
			else:
				if debug:
					print("状态 %s 拒绝进入" % name)
				return false
	return false

## 当前是否处于某状态
func is_state(name: StringName) -> bool:
	return current_state != null and current_state.state_name == name

## 当前状态名
func get_state_name() -> StringName:
	return current_state.state_name if current_state else &""

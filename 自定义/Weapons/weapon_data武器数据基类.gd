@icon("res://资产库/物品图标/icon_weapon.png")
class_name WeaponData  extends Resource

@export var weapon_name: String = "手枪"
@export var live_shells := 3
@export var blank_shells := 2
@export var max_shells := 6
@export var model_scene: PackedScene
@export var icon: Texture2D

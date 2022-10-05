extends Node

export var energy = 0

var collected_coins = 0
var zuparicu_collected = false

func _ready():
	collected_coins = 0
	zuparicu_collected = false
	
func hurt(strength):
	energy -= strength
	get_tree().call_group("GUI", "set_progress_bar_value", energy)
	
	if energy <= 0:
		get_tree().call_group("player", "die")
		
func get_coin():
	collected_coins += 1
	get_tree().call_group("GUI", "set_coins", str(collected_coins))
	
func get_zuparicu():
	zuparicu_collected = true
	get_tree().call_group("GUI", "set_zuparicu", true)

func update_game_manager():
	GameManager.set_level_watermelon(zuparicu_collected)
	GameManager.set_level_collected_coins(collected_coins)
	GameManager.set_level_completed()

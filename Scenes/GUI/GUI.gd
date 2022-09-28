extends CanvasLayer

var progress_bar
var coin_counter_label
var zuparicu_texture_off
var zuparicu_texture_on

func _ready():
	progress_bar = $Control/MyProgressBar
	progress_bar.set_value(100)
	coin_counter_label = $Control/CoinCounterLabel
	coin_counter_label.text = "0"
	zuparicu_texture_off = $Control/ZuparicuTextureRect_off
	zuparicu_texture_on = $Control/ZuparicuTextureRect_on
	
func set_progress_bar_value(value):
	progress_bar.set_value(value)

func set_coins(value):
	coin_counter_label.text = value

func set_zuparicu(value):
	if value:
		zuparicu_texture_on.visible = true
	else:
		zuparicu_texture_on.visible = false

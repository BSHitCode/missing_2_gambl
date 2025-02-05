extends Button


const sound_on_picture = preload("res://scenes/games/Bingo/sound_on.png")
const sound_off_picture = preload("res://scenes/games/Bingo/sound_off.png")

var texture_button: TextureRect
func _ready() -> void:
	texture_button = $TextureButton
	owner.is_sound = false
	texture_button.texture = sound_off_picture
	

func _on_button_down() -> void:
	owner.is_sound = !owner.is_sound
	if owner.is_sound:
		texture_button.texture = sound_on_picture
	else:
		texture_button.texture = sound_off_picture

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_button = find_child("Start", true, false) # Recursively searches for "Start"
	if start_button:
		start_button.grab_focus()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GamblSelect.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Options.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit(0)

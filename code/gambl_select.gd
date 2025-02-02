extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu_button = find_child("Menu", true, false) # Recursively searches for "Start"
	if menu_button:
		menu_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")


func _on_slots_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/games/Slots/Slots.tscn")


func _on_roulette_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/games/Roulette/Roulette.tscn")


func _on_pairs_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/games/Pairs/main.tscn")

# detects key press
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")

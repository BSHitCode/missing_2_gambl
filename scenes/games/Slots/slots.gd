extends Control

var w1_pos_vec: Vector2
var w1_1
var w1_2
var w1_3
var panel
var w_array: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var menu_button = find_child("Menu", true, false)
	#if menu_button:
		#menu_button.grab_focus()
	
	panel = $MarginContainer/HBoxContainer/Panel
	$MarginContainer/HBoxContainer/Panel/Wheel1.move_local_x(100, true)
	
	w1_1 = $MarginContainer/HBoxContainer/Panel/Wheel1
	w1_2 = $MarginContainer/HBoxContainer/Panel/Wheel1.duplicate()
	w1_3 = $MarginContainer/HBoxContainer/Panel/Wheel1.duplicate()
	
	panel.add_child(w1_2)
	panel.add_child(w1_3)
	
	w1_1.move_local_y(100, false)
	w1_2.move_local_y(350, false)
	w1_3.move_local_y(600, false)
	
	w_array.push_back(w1_1)
	w_array.push_back(w1_2)
	w_array.push_back(w1_3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	for w in w_array:
		if w.position.y > 800:
			w.position.y = 50
		else:
			w.move_local_y(delta*200, false)

	pass


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

# detects key press
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://scenes/GamblSelect.tscn")

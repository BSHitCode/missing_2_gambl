extends Control

var w1_pos_vec: Vector2
var w1_1
var w1_2
var w1_3
var panel
var w_array: Array

const sep_height = 300
const vertica_offset = 100
var w_queue: Array[Item]

enum Rarity{
	COMMON = 50,
	UNCOMMON = 30,
	RARE = 13,
	UNIQUE = 6,
	LEGENDARY = 1
}

class Item:
	var node: Node
	var rarity: Rarity
	
	func _init(_node: Node, _rarity: Rarity):
		node = _node
		rarity = _rarity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var menu_button = find_child("Menu", true, false)
	#if menu_button:
		#menu_button.grab_focus()
	
	panel = $MarginContainer/HBoxContainer/Panel
	$MarginContainer/HBoxContainer/Panel/Wheel1.move_local_x(vertica_offset, true)
	
	w1_1 = $MarginContainer/HBoxContainer/Panel/Wheel1
	w1_2 = $MarginContainer/HBoxContainer/Panel/Wheel1.duplicate()
	w1_3 = $MarginContainer/HBoxContainer/Panel/Wheel1.duplicate()
	
	
	
	
	#_set_texture("res://scenes/games/Slots/textures/COMMON.bmp", w1_1)
	w1_1.move_local_y(sep_height, false)
	w_array.push_back(w1_1)
	
	#_set_texture("res://scenes/games/Slots/textures/UNCOMMON.bmp", w1_2)
	panel.add_child(w1_2)
	w1_2.move_local_y(sep_height*2, false)
	
	#_set_texture("res://scenes/games/Slots/textures/RARE.bmp", w1_3)
	panel.add_child(w1_3)
	w1_3.move_local_y(sep_height*3, false)
	
	
	w_array.push_back(w1_2)
	w_array.push_back(w1_3)
	
	var item: Item = Item.new(w1_1, Rarity.COMMON)
	
	w_queue = _fill_queue(3, [item])
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	for i in range(3):
		var node = w_array.pop_front()
		
		if node.position.y > sep_height * 3:
			node.position.y -= sep_height * 3
		else:
			node.move_local_y(delta*200, false)
		
		w_array.push_back(node)
	
	#for w in w_array:
		#if w.position.y > 800:
			#w.position.y -= 800
		#else:
			#w.move_local_y(delta*200, false)
	#pass


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

# detects key press
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().change_scene_to_file("res://scenes/GamblSelect.tscn")

# gets node from name
func _get_node_from_name(name: String) -> Node:
	return find_child(name, true, false)

func _fill_queue(count: int, items: Array[Item]) -> Array[Item]:
	var fill_arr: Array[Item]
	
	var rarity_count: int = 0
	var item_count: int = 0
	
	for item in items:
		#item_count = (Rarity.COMMON / 100) * count
		match item.rarity:
			Rarity.COMMON:
				rarity_count += 1
			Rarity.UNCOMMON:
				rarity_count += 10
			Rarity.RARE:
				rarity_count += 100
			Rarity.UNIQUE:
				rarity_count += 1000
			Rarity.LEGENDARY:
				rarity_count += 10000
	
	var dir_count: int = 0
	for item in items:
		match item.rarity:
			Rarity.COMMON:
				item_count = (rarity_count / 1) % 10
			Rarity.UNCOMMON:
				item_count = (rarity_count / 10) % 10
			Rarity.RARE:
				item_count = (rarity_count / 100) % 10
			Rarity.UNIQUE:
				item_count = (rarity_count / 1000) % 10
			Rarity.LEGENDARY:
				item_count = (rarity_count / 10000) % 10
		
		for i in range(item_count / count):
			if dir_count % 2:
				fill_arr.push_back(item)
			else:
				fill_arr.push_front(item)
			dir_count += 1;
	
	return fill_arr

func _set_texture(path: String, node: Node) -> void:
	node.get_child(0).get_child(0).set_texture(_get_texture(path))

func _get_texture(path: String) -> ImageTexture:
	var image = Image.load_from_file(path)
	return ImageTexture.create_from_image(image)

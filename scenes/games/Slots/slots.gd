extends Control

var w1_array_show: Array
var w1_array_hide: Array

var w2_array_show: Array
var w2_array_hide: Array

var w3_array_show: Array
var w3_array_hide: Array

const sep_height: int = 300
var sep_count: int = 0
const vertica_offset: int = 100
# visible items:
const wheel_item_count: int = 5
# total items

const speed: int = 800
var slot1: int = 1
var slot2: int = 1
var slot3: int = 1
var slot_count: int = 0

var active_items: int = 0

var w1_queue: Array[Item]
var w2_queue: Array[Item]
var w3_queue: Array[Item]
# when should the order be switched
var item_shuffle: int = 3

enum Rarity{
	COMMON = 20,
	UNCOMMON = 15,
	RARE = 13,
	UNIQUE = 6,
	LEGENDARY = 1
}

class Item:
	var node: Node
	var rarity: Rarity
	
	func _init(_node: Node, _rarity: Rarity, container: Node):
		node = _node#.duplicate()
		node.set_deferred("visible", 0)
		container.add_child(node)
		rarity = _rarity

#class ItemArrCount:
	#var items: Array[Item]
	#var count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var menu_button = find_child("Menu", true, false)
	#if menu_button:
		#menu_button.grab_focus()
	var panel1: Node = $MarginContainer/HBoxContainer/Panel1
	var wheel1: Node = $MarginContainer/HBoxContainer/Panel1/Wheel1
	_create_nodes(panel1, wheel1, w1_queue, w1_array_show, w1_array_hide, 10, vertica_offset)
	
	var panel2: Node = $MarginContainer/HBoxContainer/Panel2
	var wheel2: Node = $MarginContainer/HBoxContainer/Panel2/Wheel2
	_create_nodes(panel2, wheel2, w2_queue, w2_array_show, w2_array_hide, 20, vertica_offset)# * 3.3)
	
	var panel3: Node = $MarginContainer/HBoxContainer/Panel3
	var wheel3: Node = $MarginContainer/HBoxContainer/Panel3/Wheel3
	_create_nodes(panel3, wheel3, w3_queue, w3_array_show, w3_array_hide, 30, vertica_offset)# * 5.6)
	pass

func _create_nodes(panel: Node, wheel: Node, queue: Array[Item], array_show: Array, array_hide: Array, t_item_count: int, offset: float) -> void:
	
	var w1_1
	var w1_2
	var w1_3
	var w1_4
	var w1_5
	var w1_6
	var w1_7

	wheel.set_deferred("visible", 0)
	
	w1_1 = wheel.duplicate()
	w1_1.move_local_x(offset, true)
	var pos = w1_1.get_position()
	pos.y = 0.0
	w1_1.set_position(pos)
	w1_1.set_deferred("visible", 0)
	
	w1_2 = w1_1.duplicate()
	w1_2.set_deferred("visible", 0)
	w1_3 = w1_1.duplicate()
	w1_3.set_deferred("visible", 0)
	w1_4 = w1_1.duplicate()
	w1_4.set_deferred("visible", 0)
	w1_5 = w1_1.duplicate()
	w1_5.set_deferred("visible", 0)
	
	_set_texture("res://scenes/games/Slots/textures/COMMON.bmp", w1_1)
	w1_1.move_local_y(sep_height * 0, false)
	
	_set_texture("res://scenes/games/Slots/textures/UNCOMMON.bmp", w1_2)
	panel.add_child(w1_2)
	w1_2.move_local_y(sep_height * 1, false)
	
	_set_texture("res://scenes/games/Slots/textures/RARE.bmp", w1_3)
	panel.add_child(w1_3)
	w1_3.move_local_y(sep_height * 2, false)
	
	_set_texture("res://scenes/games/Slots/textures/UNIQUE.bmp", w1_4)
	panel.add_child(w1_4)
	w1_4.move_local_y(sep_height * 3, false)
	
	_set_texture("res://scenes/games/Slots/textures/LEGENDARY.bmp", w1_5)
	panel.add_child(w1_5)
	w1_5.move_local_y(sep_height * 4, false)
	
	
	array_show.push_back(w1_1)
	array_show.push_back(w1_2)
	array_show.push_back(w1_3)
	array_show.push_back(w1_4)
	array_show.push_back(w1_5)

	var item: Item = null
	queue = _fill_queue(t_item_count, [
		Item.new(w1_1, Rarity.COMMON, panel),
		Item.new(w1_2, Rarity.UNCOMMON, panel),
		Item.new(w1_3, Rarity.RARE, panel),
		Item.new(w1_4, Rarity.UNIQUE, panel),
		Item.new(w1_5, Rarity.LEGENDARY, panel)
		])
	for i in range(t_item_count):
		item = queue.pop_front()
		if item == null:
			break
		if array_show.size() <	wheel_item_count:
			array_show.push_back(item.node)
		else:
			array_hide.push_back(item.node)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_draw_wheels(w1_array_show, w1_array_show, delta		* slot1)
	_draw_wheels(w2_array_show, w2_array_show, delta*1.2	* slot2)
	_draw_wheels(w3_array_show, w3_array_show, delta*1.4	* slot3)

func _draw_wheels(array_show: Array, array_hide: Array, delta: float) -> void:
	var node: Node
	
	for i in range(wheel_item_count):
		node = array_show[0]
		node.set_deferred("visible", 1)
		
		if node.position.y > sep_height * wheel_item_count:
			node.position.y -= sep_height * wheel_item_count
			node.set_deferred("visible", 0)
			# swap between visible and hidden arrays
			if not array_hide.is_empty():
				node = array_hide.pop_front()
				array_show.push_back(node)
			array_hide.push_back(array_show.pop_front())
		else:
			node.move_local_y(delta * speed, false)
			array_show.push_back(array_show.pop_front())


func _on_button_pressed() -> void:
	match slot_count:
		0:
			slot1 = 0
		1:
			slot2 = 0
		2:
			slot3 = 0
	slot_count += 1
	pass


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
	var fill_arr: Array[Item] = []
	
	# sort items by rarity
	var rarity_map: Dictionary = {
		Rarity.LEGENDARY: [],
		
		Rarity.UNCOMMON: [],
		
		Rarity.RARE: [],
		
		Rarity.COMMON: [],
		
		Rarity.UNIQUE: []
	}
	
	for item in items:
		rarity_map[item.rarity].push_back(item)
	
	# fill array based on rarity weight
	for rarity in rarity_map.keys():
		var arr: Array = rarity_map[rarity]
		if arr.is_empty():
			continue  # skip empty rarity
		
		for item in arr as Array[Item]:
			var r: int = int((count * (item.rarity / 100.0)) / arr.size())
			for i in range(r):
				if fill_arr.size() >= count:
					return fill_arr  # early exit
				var height = _get_sep_height()
				var insert_item = Item.new(item.node.duplicate(), item.rarity, item.node.get_parent())
				var pos = item.node.get_position()
				pos.y = 0.0
				insert_item.node.set_position(pos)
				print(((randi() % item_shuffle) == 2))
				if ((randi() % item_shuffle) == 2):
					fill_arr.push_back(insert_item)
				else:
					fill_arr.push_front(insert_item)
	print(" ")
	# do not exceed count
	return fill_arr.slice(0, count)



func _set_texture(path: String, node: Node) -> void:
	node.get_child(0).get_child(0).set_texture(_get_texture(path))

func _get_texture(path: String) -> ImageTexture:
	var image = Image.load_from_file(path)
	return ImageTexture.create_from_image(image)

func _get_sep_height() -> int:
	var count: int = sep_count
	if sep_count < wheel_item_count:
		sep_count += 1
	else:
		sep_count = 0
	return 0# count * sep_height

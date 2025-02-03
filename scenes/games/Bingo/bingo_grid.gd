extends GridContainer

signal number_selected(bingo_number)
signal gacha_display_end()
signal line_display_end()

@export var bingo_template: Control

var bingo_numbers: Array = []:
	get:
		return bingo_numbers
	set(value):
		bingo_numbers = value
		_update_menu_items()

var number_process: int = 0
var line_process: int = 0

func _ready() -> void:
	number_selected.connect(_print)
	owner.hit.connect(_on_number_get_hit.bind(false))
	owner.repeat.connect(_on_number_get_hit.bind(true))
	owner.line_trigger.connect(_on_line_trigger)

	visibility_changed.connect(func():
		if visible and get_menu_items().size() > 0:
			get_menu_items()[0].grab_focus()
	)

	if is_instance_valid(bingo_template):
		bingo_template.hide()

# debugging function to print selected number
func _print(node) -> void:
	print(node.text)

# update the menu items based on the bingo numbers
func _update_menu_items() -> void:
	# remove existing items (except the template)
	for item in get_children():
		if item == bingo_template:
			continue
		remove_child(item)
		item.queue_free()

	# Add new items for each bingo number
	if bingo_numbers.size() > 0:
		for bingo in bingo_numbers:
			var item: Control
			if is_instance_valid(bingo_template):
				item = bingo_template.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS)
				item.show()
			else:
				item = Button.new()

			item.name = "bingoNumber_%d" % get_child_count()
			item.text = str(bingo.number)

			add_child(item)

		_configure_focus()

# handle when a number is hit or repeated
func _on_number_get_hit(number: int = -1, isRepeat: bool = false) -> void:
	number_process += 1

	var items = get_menu_items()
	for i in items.size():
		var item: Control = items[i]
		
		if item.text == str(number):
			var color = Color.DARK_RED if isRepeat else Color.LAWN_GREEN
			item.modulate = color

			await get_tree().create_timer(0.8).timeout

			if not item:
				continue

			item.modulate = Color.YELLOW

	number_process -= 1

	if number_process == 0:
		gacha_display_end.emit()

# handle line triggers (e.g., completed bingo lines)
func _on_line_trigger(number_array: Array = []) -> void:
	if number_process > 0:
		await gacha_display_end

	var items = get_menu_items()
	var highlighted_items = []

	for i in items.size():
		var item: Control = items[i]
		
		if number_array.has(int(item.text)):
			highlighted_items.append(item)

	var tween = create_tween()

	for item in highlighted_items:
		tween.tween_property(item, "modulate", Color.AQUA, 0.3)
	
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	await tween.finished

	for item in highlighted_items:
		if not item:
			continue
		item.modulate = Color.YELLOW

	line_display_end.emit()

# configure focus for keyboard and mouse navigation
func _configure_focus() -> void:
	var items = get_menu_items()

	for i in items.size():
		var item: Control = items[i]

		item.focus_mode = Control.FOCUS_ALL

		item.focus_neighbor_left = item.get_path()
		item.focus_neighbor_right = item.get_path()

		if i == 0:
			item.focus_neighbor_top = item.get_path()
			item.focus_previous = item.get_path()
			item.focus_neighbor_left = item.get_path()
		else:
			if i - 5 > -1:
				item.focus_neighbor_top = items[i - 5].get_path()
			else:
				item.focus_neighbor_top = items[i - 1].get_path()
			
			item.focus_neighbor_left = items[i - 1].get_path()
			item.focus_previous = items[i - 1].get_path()

		if i == items.size() - 1:
			item.focus_neighbor_bottom = item.get_path()
			item.focus_next = items[0].get_path()
			item.focus_neighbor_right = item.get_path()
		else:
			if items.size() > i + 5:
				item.focus_neighbor_bottom = items[i + 5].get_path()
			else:
				item.focus_neighbor_bottom = item.get_path()
			
			item.focus_neighbor_right = items[i + 1].get_path()
			item.focus_next = items[i + 1].get_path()

	items[0].grab_focus()

# handle mouse hover over a bingo number
func _on_bingo_number_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name:
		return
	
	item.grab_focus()

# handle GUI input events for a bingo number
func _on_bingo_number_gui_input(event: InputEvent, item: Control) -> void:
	if "Disallowed" in item.name:
		return
	
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		number_selected.emit(item)
	elif event.is_action_pressed("ui_accept") and item in get_menu_items():
		number_selected.emit(item)

func get_menu_items() -> Array:
	var items: Array = []

	for child in get_children():
		if not child.visible or "Disallowed" in child.name:
			continue
		
		items.append(child)

	return items
	

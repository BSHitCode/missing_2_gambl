extends TileMap

# game config
const BOARD_SIZE := 4
const FLIP_BACK_DELAY := 1.5
const SOURCE_ID := 0  # Main tileset source ID
const FACE_DOWN_TILE_COORDS := Vector2(6, 2)
const FACE_DOWN_ALT_ID := 1

enum Layer { HIDDEN, REVEALED }

var score := 0
var turns_taken := 0
var revealed_cells := []
var cell_to_atlas_map := {}  # maps board positions to tile atlas coordinates

func _ready() -> void:
	initialize_board()
	update_ui()

func initialize_board() -> void:
	var shuffled_pairs = generate_shuffled_tile_pairs()
	
	for row in BOARD_SIZE:
		for col in BOARD_SIZE:
			var cell_position := Vector2(col, row)
			place_face_down_card(cell_position)
			
			var atlas_coords = shuffled_pairs.pop_back()
			cell_to_atlas_map[cell_position] = atlas_coords
			set_cell(Layer.REVEALED, cell_position, SOURCE_ID, atlas_coords)

func generate_shuffled_tile_pairs() -> Array:
	var pairs := []
	var tile_options = range(10)
	tile_options.shuffle()
	
	# generate pairs for a 4x4 board (8 pairs total)
	for pair_index in (BOARD_SIZE * BOARD_SIZE) / 2:
		var tile = Vector2(tile_options.pop_back(), 1)
		pairs.append_array([tile, tile])  # add two copies for each pair
	
	pairs.shuffle()
	return pairs

func place_face_down_card(cell: Vector2) -> void:
	set_cell(Layer.HIDDEN, cell, SOURCE_ID, FACE_DOWN_TILE_COORDS, FACE_DOWN_ALT_ID)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.is_pressed():
		return
	
	var clicked_cell := get_clicked_cell_position(event)
	if is_valid_selection(clicked_cell):
		reveal_card(clicked_cell)
		check_pair_completion()

func get_clicked_cell_position(event: InputEventMouseButton) -> Vector2:
	var global_pos := event.position
	return local_to_map(to_local(global_pos))

func is_valid_selection(cell: Vector2) -> bool:
	return (
		get_cell_alternative_tile(Layer.HIDDEN, cell) == FACE_DOWN_ALT_ID
		and revealed_cells.size() < 2
	)

func reveal_card(cell: Vector2) -> void:
	set_cell(Layer.HIDDEN, cell, -1)  # remove hidden layer tile
	revealed_cells.append(cell)

func check_pair_completion() -> void:
	if revealed_cells.size() < 2:
		return
	
	if cards_match():
		handle_matched_pair()
	else:
		reset_mismatched_pair()
	
	turns_taken += 1
	update_ui()

func cards_match() -> bool:
	return cell_to_atlas_map[revealed_cells[0]] == cell_to_atlas_map[revealed_cells[1]]

func handle_matched_pair() -> void:
	score += 1
	revealed_cells.clear()

func reset_mismatched_pair() -> void:
	await get_tree().create_timer(FLIP_BACK_DELAY).timeout
	for cell in revealed_cells:
		place_face_down_card(cell)
	revealed_cells.clear()

func update_ui() -> void:
	$"../CanvasLayer/score_label".text = "Score: %d" % score
	$"../CanvasLayer/turns_label".text = "Turns Taken: %d" % turns_taken

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

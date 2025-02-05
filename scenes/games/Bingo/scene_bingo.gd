extends CanvasLayer

signal hit(bingo)
signal repeat(bingo)
signal line_trigger(bingo_nums_array)

@onready var bingo_grid: GridContainer = get_node("MarginContainer/bingoGridContainer")
@onready var bingo_label_total_gacha: Label = get_node("MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Label2")
@onready var gacha_history: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel
@onready var reset_button: Button = $ResetButton
@onready var gacha_result_total_display: VBoxContainer = $HBoxContainer
@onready var gacha_result_total_display_label: Label = $HBoxContainer/Label2
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

var bingo_lines: Dictionary = {}
var bingo_numbers: Array = []
var bingoBoard: Array = []
var bingo_total_gacha: int = 0:
	set(value):
		if not bingo_label_total_gacha:
			await ready
		bingo_label_total_gacha.text = str(value) + " times"
		gacha_result_total_display_label.text = bingo_label_total_gacha.text
		bingo_total_gacha = value

@export var is_sound: bool = true

enum HITTYPE {
	HIT,
	REPEAT,
	FAILED
}

class bingo:
	var number: int = 0
	var is_get: bool = false

## Core Functions
func _ready() -> void:
	DisplayServer.window_set_title("BINGO")
	_init_bingo_table() 


func _init_bingo_table() -> void:
	_init_bingo_lines()
	_reset_game_state()
	_generate_bingo_numbers()
	_setup_bingo_board()

func _init_bingo_lines() -> void:
	for i in 5:
		bingo_lines["row_" + str(i + 1)] = false
		bingo_lines["col_" + str(i + 1)] = false
	bingo_lines["crosslt_rb"] = false
	bingo_lines["crossrt_lb"] = false

func _reset_game_state() -> void:
	bingo_total_gacha = 0
	bingoBoard.clear()
	bingo_numbers.clear()
	gacha_result_total_display.hide()

func _generate_bingo_numbers() -> void:
	var range_values := Vector2i(1, 100)
	for n in 25:
		var randomNumber: int
		while true:
			if n == 7:
				range_values = _gen_bingo_range()
			randomNumber = randi_range(range_values.x, range_values.y)
			if not _is_bingo_exists(randomNumber):
				break
		var new_bingo = bingo.new()
		new_bingo.number = randomNumber
		bingo_numbers.push_back(new_bingo)
	bingo_grid.bingo_numbers = bingo_numbers

func _setup_bingo_board() -> void:
	for i in 5:
		var temp_array := []
		for j in 5:
			temp_array.append(bingo_numbers[i * 5 + j])
		bingoBoard.append(temp_array)

## game logic
func _start_bingo() -> void:
	if is_sound:
		audio_stream_player.play()
	
	var player_got := _get_hit_bingos_size()
	var pickup_out_number := _calculate_pickup_number(player_got)
	
	if player_got != bingo_numbers.size():
		bingo_total_gacha += 1
	
	var hit_type := _confirm_bingo_hit(pickup_out_number)
	_process_hit_result(hit_type, pickup_out_number)
	_check_bingo_lines()
	
	if player_got == bingo_numbers.size() - 1 and hit_type == HITTYPE.HIT:
		await _handle_game_completion()

func _calculate_pickup_number(player_got: int) -> int:
	var random_ring_out: int = floor(player_got/5)
	for n in random_ring_out:
		if randi_range(1, 100) > floor(bingo_total_gacha / 200):
			random_ring_out -= 1
	
	var range := Vector2(random_ring_out * -1, random_ring_out)
	var base_number: int = bingo_numbers.pick_random().number
	range.x = clamp(base_number + range.x, 1, 100)
	range.y = clamp(base_number + range.y, 1, 100)
	return randi_range(range.x, range.y)

func _process_hit_result(hit_type: HITTYPE, number: int) -> void:
	match hit_type:
		HITTYPE.HIT:
			gacha_history.text += "Congratulations, you got {0}!\n".format([number])
			hit.emit(number)
		HITTYPE.REPEAT:
			gacha_history.text += "You got a duplicate {0}!\n".format([number])
			repeat.emit(number)
		HITTYPE.FAILED:
			gacha_history.text += "Missed with {0}\n".format([number])

func _handle_game_completion() -> void:
	while true:
		if is_sound:
			audio_stream_player_2.play()
			await audio_stream_player_2.finished
		else:
			await get_tree().physics_frame
	reset_button.show()
	gacha_result_total_display.show()

## bingo check function
func _check_bingo_lines() -> Array:
	var completed_lines: Array[String] = []
	
	for i in 5:
		_check_line(completed_lines, i, true)  # check row
		_check_line(completed_lines, i, false) # check column
	
	
	_check_diagonal(completed_lines, true)  # left to right
	_check_diagonal(completed_lines, false) # right to left
	
	return completed_lines

func _check_line(completed_lines: Array, index: int, is_row: bool) -> void:
	var hit_count := 0
	var numbers := []
	var line_name := "row_" if is_row else "col_"
	line_name += str(index + 1)
	
	for j in 5:
		var bn = bingoBoard[index][j] if is_row else bingoBoard[j][index]
		if _is_bingo_hit(bn):
			hit_count += 1
			numbers.append(bn.number)
	
	if hit_count >= 5:
		completed_lines.append(line_name)
		if not bingo_lines[line_name]:
			bingo_lines[line_name] = true
			line_trigger.emit(numbers)

func _check_diagonal(completed_lines: Array, is_left_to_right: bool) -> void:
	var hit_count := 0
	var numbers := []
	var line_name := "crosslt_rb" if is_left_to_right else "crossrt_lb"
	
	for i in 5:
		var j := i if is_left_to_right else 4 - i
		var bn: bingo = bingoBoard[j][i]
		if _is_bingo_hit(bn):
			hit_count += 1
			numbers.append(bn.number)
	
	if hit_count >= 5:
		completed_lines.append(line_name)
		if not bingo_lines[line_name]:
			bingo_lines[line_name] = true
			line_trigger.emit(numbers)

## helper functions
func _confirm_bingo_hit(number: int) -> HITTYPE:
	var bingo_instance := _bingo_number_repeat_search(number)
	if not bingo_instance:
		return HITTYPE.FAILED
	if bingo_instance.is_get:
		return HITTYPE.REPEAT
	bingo_instance.is_get = true
	return HITTYPE.HIT

func _bingo_number_repeat_search(number: int) -> bingo:
	for bingo_instance in bingo_numbers:
		if bingo_instance.number == number:
			return bingo_instance
	return null

func _is_bingo_exists(number: int) -> bool:
	return _bingo_number_repeat_search(number) != null

func _is_bingo_hit(bingo_instance: bingo) -> bool:
	return bingo_instance.is_get

func _get_hit_bingos_size() -> int:
	var count := 0
	for bingo_instance in bingo_numbers:
		if bingo_instance.is_get:
			count += 1
	return count

func _gen_bingo_range() -> Vector2i:
	var range := Vector2i(0, 999)
	for bn in bingo_numbers:
		range.x = max(range.x, bn.number)
		range.y = min(range.y, bn.number)
	
	var randiff := range.y - range.x
	if randiff < 25:
		var range_fixed := 25 - randiff
		if range.y + range_fixed < 100:
			range.y += range_fixed
		elif range.x - range_fixed > 0:
			range.x -= range_fixed
	return range

## signal handlers
func _on_single_draw_button_down() -> void:
	_start_bingo()

func _on_ten_draw_button_down() -> void:
	for n in 10:
		_start_bingo()
		await get_tree().create_timer(0.1).timeout

func _on_reset_button_button_down() -> void:
	reset_button.hide()
	_init_bingo_table()
	gacha_history.text = ""
	


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

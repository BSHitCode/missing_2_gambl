extends Sprite2D

@export var spin_duration: float = 15.0  # Wie lange sich das Rad dreht (Sekunden)
@export var start_speed: float = 10.0  # Startgeschwindigkeit der Drehung
@export var number_count: int = 37  # Anzahl der Zahlen auf dem Rad



var spinning := false
var timer := 0.0
var current_speed := 0.0
var winning_number: int = 0  # Gewinnernummer

var green = [0]
var red = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
var black = [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]

func _process(delta):
	if spinning:
		timer -= delta
		current_speed = lerp(start_speed, 0.0, 1.0 - (timer / spin_duration))  # Geschwindigkeit nimmt ab
		rotation += current_speed * delta  # Rotation basierend auf neuer Geschwindigkeit
		
		if timer <= 0:
			spinning = false
			rotation = 0  # Reset der Rotation
			determine_winning_number()

func start_spin():
	if not spinning:
		spinning = true
		timer = spin_duration  # Timer setzen
		current_speed = start_speed  # Startgeschwindigkeit setzen
		rotation = 0  # Rad zurücksetzen

func determine_winning_number():
	winning_number = randi() % number_count  # Zufällige Zahl auswählen
	print("Gewinnernummer:", winning_number)

func check_win(color: String):
	if winning_number in green and color == "green":
		print("Gewonnen! Die Zahl ", winning_number, " ist grün.")
	elif winning_number in red and color == "red":
		print("Gewonnen! Die Zahl ", winning_number, " ist rot.")
	elif winning_number in black and color == "black":
		print("Gewonnen! Die Zahl ", winning_number, " ist schwarz.") 	
	else:
		print("Verloren! Die Zahl war ", winning_number) 
		

func check_win_oddOrnot(module: String):
	if winning_number%2 == 0 and module == "even":
		print("Gewonnen! Die Zahl ", winning_number, " ist gerade")
	elif winning_number%2 != 0 and module == "odd":
		print("Gewonnen! Die Zahl ", winning_number, " ist ungerade")
	else:
		print("Verloren! Die Zahl war ", winning_number)
		
		
func check_win_number(number: int):
	if winning_number == number:
		print("Gewonnen! Die Zahl ", winning_number, " hat gewonnen")
	else :
		print("Verloren! Die Zahl ", winning_number, " hat gewonnen")	
		

func _on_grün_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win("green")
	

func _on_rot_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win("red")

func _on_schwarz_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win("black")
	

func _on_gerade_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_oddOrnot("even")

func _on_ungerade_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_oddOrnot("odd")





func _on_one_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(1)


func _on_two_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(2)


func _on_three_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(3)


func _on_four_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(4)


func _on_five_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(5)


func _on_six_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(6)


func _on_seven_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(7)


func _on_eight_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(8)


func _on_nine_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(9)


func _on_ten_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(10)


func _on_eleven_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(11)


func _on_twelve_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(12)


func _on_thirteen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(13)


func _on_fourteen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(14)


func _on_fiveteen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(15)


func _on_sixteen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(16)


func _on_seventeen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(17)


func _on_eightteen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(18)


func _on_nineteen_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(19)


func _on_twenty_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(20)


func _on_twentyone_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(21)


func _on_twentytwo_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(22)


func _on_twentythree_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(23)


func _on_twentyfour_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(24)


func _on_twentyfive_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(25)


func _on_twentysix_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(26)


func _on_twentyseven_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(27)


func _on_twentyeight_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(28)


func _on_twentynine_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(29)


func _on_thirty_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(30)


func _on_thityone_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(31)


func _on_thirtytwo_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(32)


func _on_thirtythree_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(33)


func _on_thirtyfour_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(34)


func _on_thirtyfive_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(35)


func _on_thirtysix_pressed() -> void:
	start_spin()
	await get_tree().create_timer(spin_duration).timeout
	check_win_number(36)

extends Sprite2D

@export var spin_duration: float = 15.0  # Wie lange sich das Rad dreht (Sekunden)
@export var start_speed: float = 10.0  # Startgeschwindigkeit der Drehung
@export var number_count: int = 37  # Anzahl der Zahlen auf dem Rad

var spinning := false
var timer := 0.0
var current_speed := 0.0
var winninnumber2 : int = 0

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
			determine_winning_number()

func start_spin():
	if not spinning:
		spinning = true
		timer = spin_duration  # Timer setzen
		current_speed = start_speed  # Startgeschwindigkeit setzen

func determine_winning_number():
	var normalized_rotation = fmod(rotation, 360)  # Winkel auf 0-360 normalisieren
	if normalized_rotation < 0:
		normalized_rotation += 360
		
	var segment_size = 360.0 / number_count  # Winkel pro Zahl
	var winning_number = int((normalized_rotation + segment_size / 2) / segment_size) % number_count
	winninnumber2 = winning_number
	print("Gewinnernummer:", winning_number)
	
	
func check_win(color: String):
	if winninnumber2 in green and color == "green":
		print("Gewonnen! Die Zahl ", winninnumber2, " ist grün.")
	elif winninnumber2 in red and color == "red":
		print("Gewonnen! Die Zahl ", winninnumber2, " ist rot.")
	elif winninnumber2 in black and color == "black":
		print("Gewonnen! Die Zahl ", winninnumber2, " ist schwarz.") 	
	else:
		print("Verloren! Die Zahl war ", winninnumber2) 

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
	

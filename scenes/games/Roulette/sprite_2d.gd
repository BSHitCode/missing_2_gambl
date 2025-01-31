extends Sprite2D


@export var rotation_speed: float = 5.0  # Anfangsgeschwindigkeit der Drehung
@export var deceleration: float = 0.05  # Verlangsamung pro Frame
@export var number_count: int = 36  # Anzahl der Zahlen auf dem Rad

var spinning := false
var current_speed := 0.0

func _ready():
	pass

func _process(delta):
	if spinning:
		current_speed = max(0, current_speed - deceleration * delta)
		rotation += current_speed * delta  # Dreht das Rad
		
		if current_speed <= 0:
			spinning = false
			determine_winning_number()

func start_spin():
	if not spinning:
		spinning = true
		current_speed = rotation_speed

func determine_winning_number():
	var winning_angle = fmod(rotation, 360)  # Winkel im Bereich 0-360
	var segment_size = 360.0 / number_count  # Winkel pro Zahl
	var winning_number = int((winning_angle + segment_size / 2) / segment_size) % number_count
	print("Gewinnernummer:", winning_number)





func _on_grün_pressed() -> void:
	start_spin()


func _on_rot_pressed() -> void:
	start_spin()


func _on_schwarz_pressed() -> void:
	start_spin()

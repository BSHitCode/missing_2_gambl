extends Node2D

var frames: float = 0.0
var b: bool = false
var weel1
var collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weel1 = find_child("Weel1", true, false)
	collision = find_child("Weel1_Collision", true, false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var tick_num: int = frames / delta
	
	print(tick_num)
	
	
	
	if tick_num > 10000:
		frames = 0
		if b:
			b = false
		else:
			b = true
	
	print(b)
	
	if b:
		#weel1.visible = true
		weel1.set_deferred("visible", 1)
		collision.set_deferred("disabled", 0)
		
	else:
		#weel1.visible = false
		weel1.set_deferred("visible", 0)
		collision.set_deferred("disabled", 1)
	
	frames += 1

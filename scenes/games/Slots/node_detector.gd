extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = 0.0
const SAVE_PATH = "res://scenes/games/Slots/data/collision_data.json"


func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var direction2 := Input.get_axis("ui_up", "ui_down")
	if direction2:
		velocity.y = direction2 * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	# Handle collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider:
			var instance_id = collider.get_instance_id()
			var object_name = collider.name
			var texture_name = "Unknown"

			# Retrieve the texture name if available
			if collider.has_node("Sprite2D"):
				var sprite = collider.get_node("Sprite2D") as Sprite2D
				
				
				#sprite.texture.get_meta()
				var a = sprite.get_meta_list()
				print(a)
				
				if sprite.texture and sprite.texture.resource_path:
					texture_name = sprite.texture.resource_path.get_file()
				elif sprite.texture and sprite.texture.resource_name:
					texture_name = sprite.texture.resource_name
			elif collider.has_node("AnimatedSprite2D"):
				var anim_sprite = collider.get_node("AnimatedSprite2D") as AnimatedSprite2D
				var frame_texture = anim_sprite.sprite_frames.get_frame_texture(anim_sprite.animation, anim_sprite.frame)
				if frame_texture and frame_texture.resource_path:
					texture_name = frame_texture.resource_path.get_file()
				elif frame_texture and frame_texture.resource_name:
					texture_name = frame_texture.resource_name

			# Disable collision
			if collider.has_node("CollisionShape2D"):
				var collision_shape = collider.get_node("CollisionShape2D") as CollisionShape2D
				collision_shape.set_deferred("disabled", true)
				print("Collision disabled for:", object_name)

			# Store collision data in memory (using CollisionManager)
			CollisionManager.add_collision(object_name, instance_id, texture_name)

	move_and_slide()

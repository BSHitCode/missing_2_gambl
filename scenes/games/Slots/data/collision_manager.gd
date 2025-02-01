extends Node

var collision_data: Array = []

func add_collision(object_name: String, instance_id: int, texture_name: String) -> void:
	# Ensure the instance is not already recorded
	for entry in collision_data:
		if entry.instance_id == instance_id:
			print("Instance already recorded:", instance_id)
			return

	# Add new collision data
	var new_entry = {
		"name": object_name,
		"instance_id": instance_id,
		"texture": texture_name
	}
	collision_data.append(new_entry)
	print("Collision recorded:", new_entry)

func get_collisions() -> Array:
	return collision_data

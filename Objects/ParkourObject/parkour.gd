extends StaticBody2D

# Variable to reference the player
@export var player : Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if player.sizeProgress is >= 0.2
	var disable_colliders = player.sizeProgress >= 0.2
	
	# Iterate through all the CollisionShape2D nodes inside the StaticBody2D
	for collider in get_children():
		if collider is CollisionShape2D:
			collider.disabled = disable_colliders

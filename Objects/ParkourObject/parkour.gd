extends Node2D

# Directly expose a reference to the player node
@export var player : Node

# Array to store all CollisionShape2D nodes
var colliders : Array = []

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Optionally, you could check if player is assigned
	if player == null:
		print("Warning: Player node not assigned!")
	
	# Gather all the CollisionShape2D nodes from the StaticBody2D nodes
	collect_colliders()

# Function to collect all CollisionShape2D nodes into the colliders array
func collect_colliders() -> void:
	# Clear the array to avoid duplicates
	colliders.clear()
	
	# Iterate through all StaticBody2D nodes in this Node2D's children
	for static_body in get_children():
		if static_body is StaticBody2D:
			# Add all CollisionShape2D nodes from each StaticBody2D to the array
			for collider in static_body.get_children():
				if collider is CollisionShape2D:
					colliders.append(collider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if player.sizeProgress is >= 0.2
	var disable_colliders = player.sizeProgress >= 0.2
	
	# Cycle through the pre-collected colliders and disable them
	for collider in colliders:
		collider.disabled = disable_colliders

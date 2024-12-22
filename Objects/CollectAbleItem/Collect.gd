extends Area2D


func _ready():
	connect("body_entered", _on_body_entered)

@export var itemID:int

func _on_body_entered(body):
	if body is CharacterBody2D:
		print("Player collected item with ID " + str(itemID))
		if body.mission_controller.collect_item(itemID):
			queue_free()
		else:
			print("You do not have a mission for item " + str(itemID))

		

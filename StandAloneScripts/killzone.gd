extends Area2D

@export var respawnPoint: Node2D
var bodies_in_area: Array = []

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)


func _on_body_entered(body):
	if body is CharacterBody2D:
		bodies_in_area.append(body)


func _on_body_exited(body):
	if body is CharacterBody2D and body in bodies_in_area:
		bodies_in_area.erase(body)


func _process(delta):
	for body in bodies_in_area:
		if body.sizeProgress <= 0.2 and not body.isSafe:
			body.global_position = respawnPoint.global_position
			bodies_in_area.erase(body)  # Remove the body after processing to avoid redundant checks

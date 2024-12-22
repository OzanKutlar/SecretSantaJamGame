extends Area2D

@export var respawnPoint: Node2D


func _ready():
	# Connect signals for entering and exiting the area
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)


func _on_body_entered(body):
	if body is CharacterBody2D:
		body.isSafe = true


func _on_body_exited(body):
	if body is CharacterBody2D:
		body.isSafe = false

extends Node2D

# Declare member variables for the timer and direction
var fade_timer: float = 0.0
var fade_duration: float = 2.0  # Duration in seconds for fading
var direction: int = -1
var rich_text_label: RichTextLabel
var sprite: Sprite2D
var dialogue_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the child nodes
	rich_text_label = $RichTextLabel
	sprite = $Sprite2D
	
	# Initialize the timer node
	dialogue_timer = Timer.new()
	add_child(dialogue_timer)  # Add the timer to the scene
	dialogue_timer.connect("timeout", _on_dialogue_timeout)  # Connect the timeout signal to the callback function
	
	# Set the initial opacity to 0 (completely transparent)
	rich_text_label.modulate.a = 0.0
	sprite.modulate.a = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the fade timer based on the direction (fading in or fading out)
	fade_timer += delta * direction

	# Clamp the fade_timer between 0 and 1 (opacity range)
	fade_timer = clamp(fade_timer, 0.0, 1.0)

	# Update the opacity of the RichTextLabel and Sprite2D
	rich_text_label.modulate.a = fade_timer
	sprite.modulate.a = fade_timer
	

# Function to set the dialogue text and control fade-in and fade-out
func set_dialogue(text: String) -> void:
	print("Came Here!")
	rich_text_label.text = text
	#rich_text_label.text = "[color=black]" +  text + "[/color]"
	
	# Set the direction to 1 (start fading in)
	direction = 1
	
	# Start the fade-in process
	fade_timer = 0.0
	
	# Set a timer for 5 seconds, after which we'll start fading out
	dialogue_timer.start(5.0)  # Start the timer for 5 seconds

# Callback function that is called when the timer times out (after 5 seconds)
func _on_dialogue_timeout() -> void:
	# Set the direction to -1 (start fading out)
	direction = -1
	
	# Reset the timer so it's ready for the next dialogue if needed
	dialogue_timer.stop()

extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Enable BBCode for styling text.
	bbcode_enabled = true
	
	# Set the text with BBCode to change its color to black.
	text = "[color=black]This is black text.[/color]"

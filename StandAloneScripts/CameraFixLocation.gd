extends Camera2D

# Array to hold objects with their labels and offsets
@export var label_objects: Array = []

func _ready():
	# Validate the objects in the array
	for obj in label_objects:
		if not obj.has("label") or not obj.label:
			print("Error: Missing or invalid 'label' for object: ", obj)
			continue
		if not obj.has("xOffset") or not obj.has("yOffset"):
			print("Error: Missing 'xOffset' or 'yOffset' for object: ", obj)
			continue

func _process(_delta):
	# Update positions for all label objects
	var t = get_viewport_transform()
	var end = get_viewport().size

	for obj in label_objects:
		if not obj.has("label") or not obj.label:
			continue
		if not obj.has("xOffset") or not obj.has("yOffset"):
			continue

		# Compute position based on offset values
		var pos = t * global_position
		pos.x = obj.xOffset if obj.xOffset >= 0 else end.x + obj.xOffset
		pos.y = obj.yOffset if obj.yOffset >= 0 else end.y + obj.yOffset

		# Set the global position of the label
		get_node(obj.label).global_position = t.affine_inverse() * pos

extends Node2D

signal tile_pressed(category, value)

@onready var hotspot_container = $Hotspots


func _ready():

	var categories = [
		"Lists",
		"Array",
		"BST",
		"Queues",
		"Stacks"
	]

	var values = [100, 200, 300, 400]

	var buttons = hotspot_container.get_children()

	if buttons.size() != 20:
		print("WARNING: Need exactly 20 buttons inside Hotspots")

	var index = 0

	for c in range(categories.size()):
		for v in range(values.size()):

			if index >= buttons.size():
				return

			var btn = buttons[index]

			var category = categories[c]
			var value = values[v]

			btn.pressed.connect(func():
				print("Pressed:", category, value)
				emit_signal("tile_pressed", category, value)
			)

			index += 1

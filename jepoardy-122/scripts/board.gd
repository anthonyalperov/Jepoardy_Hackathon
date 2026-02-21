extends Node2D

signal tile_selected(category: String, value: int)

@onready var hotspots: Node2D = $Hotspots

# Categories and question values
const CATEGORIES := ["LinkedList", "Arrays", "BST", "Queues", "Stacks"]
const VALUES     := [100, 200, 300, 400]  # added 400

# Positioning (adjust to match your board.png)
@export var grid_origin := Vector2(155, 240)  # top-left of first tile (100 under LinkedList)
@export var tile_size  := Vector2(170, 86)
@export var gap        := Vector2(28, 18)

var buttons: Dictionary = {} # key "cat:value" -> Button

func _ready() -> void:
	_build_hotspots()

func _build_hotspots() -> void:
	# Clear old buttons
	for c in hotspots.get_children():
		c.queue_free()
	buttons.clear()

	for col in range(CATEGORIES.size()):
		for row in range(VALUES.size()):
			var cat = CATEGORIES[col]
			var val = VALUES[row]

			var b = Button.new()
			b.flat = true
			b.focus_mode = Control.FOCUS_NONE
			b.mouse_filter = Control.MOUSE_FILTER_STOP
			b.modulate.a = 0.0   # invisible
			b.size = tile_size
			b.position = grid_origin + Vector2(
				col * (tile_size.x + gap.x),
				row * (tile_size.y + gap.y)
			)

			# Bind the current category/value
			b.pressed.connect(func(c: String, v: int):
				emit_signal("tile_selected", c, v)
			).bind(cat, val)

			hotspots.add_child(b)
			buttons[_key(cat, val)] = b

# Disable used tiles
func refresh_used(used: Dictionary) -> void:
	for k in buttons.keys():
		var b: Button = buttons[k]
		var is_used = bool(used.get(k, false))
		b.disabled = is_used
		b.modulate.a = 0.15 if is_used else 0.0

# Helper for dictionary keys
func _key(category: String, value: int) -> String:
	return "%s:%d" % [category, value]

extends CanvasLayer

signal start_pressed
signal quit_pressed

@onready var start_btn: Button = $StartButton
@onready var quit_btn: Button = get_node_or_null("QuitButton")

func _ready() -> void:
	start_btn.pressed.connect(func(): emit_signal("start_pressed"))
	if quit_btn:
		quit_btn.pressed.connect(func(): emit_signal("quit_pressed"))

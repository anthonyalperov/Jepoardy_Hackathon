extends CanvasLayer

signal start_pressed
signal quit_pressed

@onready var start_btn: Button = $VBoxContainer/START
@onready var quit_btn: Button = $VBoxContainer/QUIT

func _ready() -> void:
	print("MENU READY")

	start_btn.pressed.connect(_on_start_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)


func _on_start_pressed():
	print("START BUTTON PRESSED")
	start_pressed.emit()


func _on_quit_pressed():
	print("QUIT BUTTON PRESSED")
	quit_pressed.emit()
	get_tree().quit()

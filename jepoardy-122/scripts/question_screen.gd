extends CanvasLayer

signal closed

@onready var image_rect: TextureRect = $QuestionImage

func show_question(image_path: String):

	visible = true

	var tex = load(image_path)

	if tex:
		image_rect.texture = tex
	else:
		print("FAILED TO LOAD:", image_path)


func _input(event):

	if visible and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			close()


func close():
	visible = false
	emit_signal("closed")

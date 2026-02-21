extends CanvasLayer

signal answered(category: String, value: int, correct: bool)
signal closed

@onready var panel: Control = $Panel
@onready var title_lbl: Label = $Panel/VBox/Title
@onready var body_lbl: Label = $Panel/VBox/Body
@onready var correct_btn: Button = $Panel/VBox/Buttons/CorrectButton
@onready var wrong_btn: Button = $Panel/VBox/Buttons/WrongButton
@onready var close_btn: Button = $Panel/VBox/Buttons/CloseButton

var current_category: String = ""
var current_value: int = 0

func _ready() -> void:
	visible = false
	panel.visible = false

	correct_btn.pressed.connect(_on_correct)
	wrong_btn.pressed.connect(_on_wrong)
	close_btn.pressed.connect(_on_close)

func open(category: String, value: int, question_text: String) -> void:
	current_category = category
	current_value = value

	title_lbl.text = "%s — $%d" % [category, value]
	body_lbl.text = question_text

	correct_btn.text = "Correct (+%d)" % value
	wrong_btn.text = "Wrong (-%d)" % value

	visible = true
	panel.visible = true

func _on_correct() -> void:
	emit_signal("answered", current_category, current_value, true)
	_hide()

func _on_wrong() -> void:
	emit_signal("answered", current_category, current_value, false)
	_hide()

func _on_close() -> void:
	emit_signal("closed")
	_hide()

func _hide() -> void:
	current_category = ""
	current_value = 0
	panel.visible = false
	visible = false

extends Node2D

@onready var gm: Node2D = $GameManager
@onready var menu:  CanvasLayer = $Menu
@onready var board: Node2D = $Board
@onready var qs: CanvasLayer = $QuestionScreen

func _ready() -> void:
	# Initial visibility
	menu.visible = true
	board.visible = false
	qs.visible = false

	# Wire signals
	menu.start_pressed.connect(_on_start_pressed)
	menu.quit_pressed.connect(_on_quit_pressed)

	board.tile_selected.connect(_on_tile_selected)

	qs.answered.connect(_on_answered)
	qs.closed.connect(_on_question_closed)

	# Load data once
	gm.load_questions("res://data/questions.json")

func _on_start_pressed() -> void:
	gm.reset_game()
	menu.visible = false
	board.visible = true
	qs.visible = false
	board.refresh_used(gm.used)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tile_selected(category: String, value: int) -> void:
	# Guard: used/missing
	if not gm.has_question(category, value):
		return
	if gm.is_used(category, value):
		return

	var q: Dictionary = gm.get_question(category, value)
	qs.open(category, value, q["q"])

func _on_answered(category: String, value: int, correct: bool) -> void:
	gm.resolve_question(category, value, correct)
	board.refresh_used(gm.used)

func _on_question_closed() -> void:
	# Nothing needed yet; hook for future
	pass

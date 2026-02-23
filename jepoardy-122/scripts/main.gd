extends Node2D

@onready var game_manager = $GameManager
@onready var menu = $Menu
@onready var board = $Board
@onready var question_screen = $QuestionScreen


func _ready():

	menu.visible = true
	board.visible = false
	question_screen.visible = false

	menu.connect("start_pressed", _on_start_pressed)
	board.connect("tile_pressed", _on_tile_pressed)
	question_screen.connect("closed", _on_question_closed)


func _on_start_pressed():
	menu.visible = false
	board.visible = true


func _on_tile_pressed(category: String, value: int):

	var image_path = "res://assets/sprites/%s%d.png" % [category, value]

	print("Loading:", image_path)

	board.visible = false
	question_screen.show_question(image_path)


func _on_question_closed():
	question_screen.visible = false
	board.visible = true

extends Node2D

signal score_changed(new_score: int)

# Categories and values
const CATEGORIES := ["LinkedList", "Arrays", "BST", "Queues", "Stacks"]
const VALUES     := [100, 200, 300, 400]

# Game state
var score := 0
var questions := {}  # questions[cat][value] = {"q": "...", "a": "..."}
var used := {}       # used["cat:value"] = bool

# Load questions from JSON file
func load_questions(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("questions.json not found: " + path)
		return

	var text = FileAccess.get_file_as_string(path)
	var parse_result = JSON.parse_string(text)
	if parse_result.error != OK:
		push_error("Failed to parse questions.json: " + parse_result.error_string())
		return

	var parsed = parse_result.result

	questions.clear()
	for cat_key in parsed.keys():
		var cat_dict = parsed[cat_key]
		if typeof(cat_dict) != TYPE_DICTIONARY:
			continue
		questions[cat_key] = {}
		for val_key in cat_dict.keys():
			var v = int(val_key)
			var qa_dict = cat_dict[val_key]
			if typeof(qa_dict) != TYPE_DICTIONARY:
				continue
			questions[cat_key][v] = {
				"q": str(qa_dict.get("q", "")),
				"a": str(qa_dict.get("a", "")),
			}

	_init_used()

# Reset score and used tiles
func reset_game() -> void:
	score = 0
	emit_signal("score_changed", score)
	_init_used()

# Initialize all tiles as unused
func _init_used() -> void:
	used.clear()
	for cat in CATEGORIES:
		for v in VALUES:
			used[_key(cat, v)] = false

# Check if a question exists
func has_question(category: String, value: int) -> bool:
	return questions.has(category) and questions[category].has(value)

# Get question
func get_question(category: String, value: int) -> Dictionary:
	return questions[category][value]

# Check if tile used
func is_used(category: String, value: int) -> bool:
	return bool(used.get(_key(category, value), false))

# Resolve question
func resolve_question(category: String, value: int, correct: bool) -> void:
	used[_key(category, value)] = true
	score += value if correct else -value
	emit_signal("score_changed", score)

# Build dictionary key
func _key(category: String, value: int) -> String:
	return "%s:%d" % [category, value]

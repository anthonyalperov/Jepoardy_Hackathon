extends Node

signal score_changed(new_score: int)

const CATEGORIES := ["LinkedList", "Arrays", "BST", "Queues", "Stacks"]
const VALUES := [100, 200, 300]

var score: int = 0
var questions: Dictionary = {}  # questions[cat][value] = {"q": "...", "a": "..."}
var used: Dictionary = {}       # used["cat:value"] = bool

func load_questions(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("questions.json not found: " + path)
		return

	var text := FileAccess.get_file_as_string(path)
	var parsed := JSON.parse_string(text)
	if parsed == null or typeof(parsed) != TYPE_DICTIONARY:
		push_error("Invalid questions.json format")
		return

	questions.clear()
	for cat in parsed.keys():
		questions[cat] = {}
		var bucket: Dictionary = parsed[cat]
		for v_str in bucket.keys():
			var v := int(v_str)
			var qa: Dictionary = bucket[v_str]
			questions[cat][v] = {
				"q": str(qa.get("q", "")),
				"a": str(qa.get("a", "")),
			}

	_init_used()

func reset_game() -> void:
	score = 0
	emit_signal("score_changed", score)
	_init_used()

func _init_used() -> void:
	used.clear()
	for cat in CATEGORIES:
		for v in VALUES:
			used[_key(cat, v)] = false

func has_question(category: String, value: int) -> bool:
	return questions.has(category) and questions[category].has(value)

func get_question(category: String, value: int) -> Dictionary:
	return questions[category][value]

func is_used(category: String, value: int) -> bool:
	return bool(used.get(_key(category, value), false))

func resolve_question(category: String, value: int, correct: bool) -> void:
	used[_key(category, value)] = true
	score += value if correct else -value
	emit_signal("score_changed", score)

func _key(category: String, value: int) -> String:
	return "%s:%d" % [category, value]

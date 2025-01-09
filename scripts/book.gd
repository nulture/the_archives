
@tool
class_name Book extends Node

const TITLE_JSON_PATH : String = "res://assets/title_data.json"

static var VOWELS : PackedStringArray = [ "a", "e", "i", "o", "u" ]
static var RANDOM := RandomNumberGenerator.new()

@export var title_label : Label3D
@export var spine_label : Label3D

@export var refresh : bool :
	get: return false
	set(value): refresh_json(); randomize_stats()
@export var predefined : bool

var _title : String
@export var title : String :
	get: return _title
	set(value):
		if _title == value: return
		_title = value
		if title_label:
			title_label.text = _title

var _author : String
@export var author : String :
	get: return _author
	set(value):
		if _author == value: return
		_author = value
		if spine_label:
			spine_label.text = _author

static var data : Dictionary
static func _static_init() -> void:
	refresh_json()


func _ready() -> void:
	if not predefined:
		randomize_stats()


static func refresh_json() -> void:
	var json_file := FileAccess.open(TITLE_JSON_PATH, FileAccess.READ)
	data = JSON.parse_string(json_file.get_as_text())


func randomize_stats() -> void:
	title = create_new_title(pick_random_from_array(data["genres"].keys()))
	author = create_new_author()


static func create_new_title(genre: String) -> String:
	var result := ""

	var mixed_nouns : Array[String]
	mixed_nouns.append_array(data["genres"]["general"]["nouns"])
	mixed_nouns.append_array(data["genres"][genre]["nouns"])

	var word_count : int = RANDOM.rand_weighted(data["word_counts"])
	var words : Array[String]
	for i in word_count:
		var word : String = pick_random_from_array(mixed_nouns)
		var suffix : String = pick_random_from_dictionary(data["noun_suffixes"])
		if suffix == "s" and word[word.length() - 1] == "y":
			word = word.substr(0, word.length() - 1) + "ies"
		else:
			word += suffix
		
		words.push_back(word)

	var i = 0
	for word in words:
		var connector : String = pick_random_from_dictionary(data["connectors_intro"] if i == 0 else data["connectors"])
		if connector == "a" and VOWELS.has(word[0]):
			connector = "an"
		result += connector
		result += " " + word
		i += 1

	return result.capitalize()


static func create_new_author(last_name_letter := "") -> String:
	var last_name_starters : Array
	if last_name_letter != "":
		last_name_starters = data["authors"]["last_names"].map(func(x) : return x[0] == last_name_letter)
	else:
		last_name_starters = data["authors"]["last_names"]

	var last_name_starter : String = pick_random_from_array(last_name_starters)
	var last_name_ender : String = pick_random_from_array(data["authors"]["last_names"])

	while last_name_ender and (last_name_ender[0] == last_name_starter[-1] or (VOWELS.has(last_name_ender[0]) and VOWELS.has(last_name_starter[-1]))):
		last_name_ender = last_name_ender.substr(1)

	var last_name = last_name_starter + last_name_ender

	var first_random := RandomNumberGenerator.new()
	first_random.seed = hash(last_name)

	var first_name : String = data["authors"]["last_names"][first_random.randi_range(0, data["authors"]["last_names"].size() - 1)]
	
	var result : String = first_name + " " + last_name
	return result.capitalize()

static func pick_random_from_array(array : PackedStringArray) -> String:
	return array[RANDOM.randi_range(0, array.size() - 1)]


static func pick_random_from_dictionary(dict : Dictionary) -> Variant:
	return dict.keys()[RANDOM.rand_weighted(dict.values() as PackedFloat32Array)]
	

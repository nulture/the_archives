
@tool
class_name BookLabel extends Label3D

static var title_intros := {
	"": 3.0,
	"the": 1.0,
	"a": 0.25,
	"of": 0.1,
	"when": 0.05,
	"to": 0.05,
	"how to": 0.1,
}
static var requires_noun_next : PackedStringArray = [
	"",
	"the",
	"a",
	"of",
	"when",
]
static var requires_verb_next : PackedStringArray = [
	"to",
	"how to"
]
static var title_connectors := {
	"": 2.0,
	"of": 1.0,
	"of the": 1.0,
	"and": 1.0,
}
static var title_nouns : PackedStringArray = [
	"magic",
	"swamp",
	"miasma",
	"buttresses",
	"frogs",
	"queen",
	"potion",
	"cauldron",
	"year",
	"matter",
	"screebo",
	"fortnight",
	"legend",
	"snotbane"
]
static var title_verbs : PackedStringArray = [
	"pick",
	"think",
	"contort",
	"disrupt",
	"mutate",
	"fracture",
	"redd",
	"scrub",
	"construct",
]
static var title_any : PackedStringArray

static var random := RandomNumberGenerator.new()

@export var predefined : bool

var _title : String
@export var title : String :
	get: return _title
	set(value):
		if _title == value: return
		_title = value
		self.text = _title


func _ready() -> void:
	if not predefined and not Engine.is_editor_hint():
		randomize_stats()


func randomize_stats() -> void:
	title = create_new_title()


static func create_new_title() -> String:
	var result := ""
	var words := 0

	var intro : String = pick_random_from_dictionary(title_intros)
	result += intro + " "
	
	if requires_noun_next.has(intro):
		var noun := pick_random_from_array(title_nouns)
		result += noun
	elif requires_noun_next.has(intro):
		var verb := pick_random_from_array(title_verbs)
		result += verb

	var connector : String = pick_random_from_dictionary(title_connectors)

	if connector != "":
		result += " " + connector + " " + pick_random_from_array(title_nouns)

	return result.capitalize()


static func pick_random_from_array(array : PackedStringArray) -> String:
	return array[random.randi_range(0, array.size() - 1)]


static func pick_random_from_dictionary(dict : Dictionary) -> Variant:
	return dict.keys()[random.rand_weighted(dict.values() as PackedFloat32Array)]
	

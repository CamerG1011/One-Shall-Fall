extends Node2D

@onready var audio = $AudioPlayer
@onready var label: RichTextLabel = $SubtitleLabel

# Delay before the first sequence starts
const INITIAL_DELAY = 2.0
# Time between words
const WORD_DELAY = 0

# First sequence: "Sacrifices must be made"
var sequence_1 = [
	{ "word": "Sacrifices", "audio": "res://Assets/Sacrifices.ogg", "color": "white" },
	{ "word": "must",       "audio": "res://Assets/Must.ogg",       "color": "white" },
	{ "word": "be",         "audio": "res://Assets/Be.ogg",         "color": "white" },
	{ "word": "made",       "audio": "res://Assets/made.ogg",       "color": "white" },
]

# Second sequence: "Sacrifices WERE made"
var sequence_2 = [
	{ "word": "Sacrifices", "audio": "res://Assets/Sacrifices.ogg", "color": "white" },
	{ "word": "WERE",       "audio": "res://Assets/Were.ogg",       "color": "red" },
	{ "word": "made",       "audio": "res://Assets/Made.ogg",       "color": "white" },
]

func _ready():
	label.clear()
	start_sequence_later(sequence_1, INITIAL_DELAY)

# Start a sequence after a delay
func start_sequence_later(seq: Array, delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	await play_caption_sequence(seq)

# Main function to play a sequence
func play_caption_sequence(seq: Array) -> void:
	label.text = ""
	
	for entry in seq:
		var word = entry["word"]
		var color = entry["color"]
		var audio_path = entry["audio"]
		
		# Play the audio
		audio.stream = load(audio_path)
		audio.play()

		# Add word to the label
		label.text += "[color=%s]%s[/color] " % [color, word]

		# Wait for audio to finish
		var duration = audio.stream.get_length()
		await get_tree().create_timer(duration + WORD_DELAY).timeout

# Example condition trigger (e.g., called by button or collision)
func trigger_second_sequence():
	await play_caption_sequence(sequence_2)

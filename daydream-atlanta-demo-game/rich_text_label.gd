extends RichTextLabel

# === Messages to display ===
var messages = [
	"You won!",
	"But at what cost?",
	"Sacrifices must be made",
	"But should they be made?",
	"Programming by Ethan Jang",
	"and maybe a hint of chatgpt",
	"Audio by Allen Hu",
	"Art by Keoni Morris",
	"Daydream Atlanta - 2025",
	"ONE SHALL FALL"
]

var index := 0

# === Setup on start ===
func _ready():
	print("RichTextLabel ready.")
	
	# Ensure label is visible and alpha is 0 for fade
	visible = true
	modulate.a = 0.0
	
	# Recommended: allow rich formatting and text wrapping
	bbcode_enabled = false
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	fit_content = true

	# Optional: increase font size for visibility (if using theme/font)
	# add_theme_font_size_override("normal_font_size", 32)

	# Start the sequence
	start_fade_cycle()

# === Start displaying messages ===
func start_fade_cycle():
	show_message(messages[index])

# === Display one message ===
func show_message(message: String) -> void:
	print("Showing message: ", message)
	text = message
	await fade_in()

# === Fade in text ===
func fade_in():
	var duration := 1.0
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		modulate.a = lerp(0.0, 1.0, t / duration)
		await get_tree().process_frame
	print("Fade-in complete.")
	await get_tree().create_timer(4.0).timeout  # Time message stays visible
	await fade_out()

# === Fade out text ===
func fade_out():
	var duration := 1.0
	var t := 0.0
	while t < duration:
		t += get_process_delta_time()
		modulate.a = lerp(1.0, 0.0, t / duration)
		await get_tree().process_frame
	print("Fade-out complete.")
	
	index += 1
	if index < messages.size():
		await get_tree().create_timer(1.0).timeout
		show_message(messages[index])
	else:
		on_messages_done()

# === What to do when all messages are done ===
func on_messages_done():
	FadeLayer.fade_to_scene("res://Scenes/StartMenu.tscn")

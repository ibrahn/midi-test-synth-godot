extends Button
class_name SynthKey

var freq := 440.0
var accumilator := 0.0
var sample_rate := 32000
var playback: AudioStreamGeneratorPlayback
var amp := 0.0
var velocity := 1.0
var atk_rate := 3.0 / sample_rate
var rel_rate := -1.0 / sample_rate
var note_on := false
@onready var player := $AudioStreamPlayer
@onready var release_timer := $ReleaseTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.stream.mix_rate = sample_rate
	player.stream.buffer_length = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.playing:
		_fill_buffer()

func _fill_buffer () -> void:
	var wave_inc = freq / sample_rate * 2.0
	var amp_inc = atk_rate if note_on else rel_rate
	for i in playback.get_frames_available():
		amp = max(0.0, min(1.0, amp + amp_inc))
		playback.push_frame(Vector2(accumilator - 1.0, accumilator - 1.0) * amp * velocity)
		accumilator = fmod(accumilator + wave_inc, 2.0)

func _start_note() -> void:
	release_timer.stop()
	note_on = true
	if not player.playing:
		player.play()
		playback = player.get_stream_playback()
	_fill_buffer()

func _end_note() -> void:
	note_on = false
	release_timer.start()

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_start_note()
	else:
		_end_note()

func midi_event(event: InputEventMIDI) -> void:
	match event.message:
		MIDI_MESSAGE_NOTE_ON:
			velocity = event.velocity / 127.0
			button_pressed = true
		MIDI_MESSAGE_NOTE_OFF:
			button_pressed = false


func _on_release_timer_timeout() -> void:
	if not note_on:
		player.stop()

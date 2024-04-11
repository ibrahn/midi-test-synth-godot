extends Control

@export var base_note_num: int = 60
var keys: Array[Node]
var bend := 0.0

func _ready() -> void:
	keys = $White.get_children() + $Black.get_children()
	keys.sort_custom(func(a, b): return str(a.name) < str(b.name))
	_update_key_freqs()

func _midi_freq(note_number: float) -> float:
	return pow(2.0, (note_number - 69.0) / 12.0) * 440.0

func _update_key_freqs() -> void:
	for i in keys.size():
		keys[i].freq = _midi_freq(base_note_num + i + bend)

func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		match event.message:
			MIDI_MESSAGE_NOTE_ON, MIDI_MESSAGE_NOTE_OFF:
				var key = _get_key(event.pitch)
				if (key):
					key.midi_event(event as InputEventMIDI)
			MIDI_MESSAGE_PITCH_BEND:
				bend = (event.pitch - 0x2000) / float(0x2000)
				_update_key_freqs()

func _get_key(note_number: int) -> SynthKey:
	var index = note_number - base_note_num
	if index < 0 or index >= 12:
		return null
	return keys[index]

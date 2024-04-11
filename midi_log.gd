extends RichTextLabel
const HIGH_LINE = 500
const LOW_LINE = 340
var log_lines = []
var scroll_bar: VScrollBar
var logging := true

func _ready() -> void:
	scroll_bar = get_v_scroll_bar()
	scroll_bar.scrolling.connect(_on_scroll)

func _on_scroll() -> void:
	scroll_following = scroll_bar.value + scroll_bar.page == scroll_bar.max_value

# Return BBCode representation of event
func event_to_BB(event: InputEventMIDI) -> String:
	var bb := ""
	match event.message:
		MIDI_MESSAGE_NOTE_OFF:
			bb = "[color=gray]Note Off   [/color]Note: [color=#ddd]%3d[/color]  Vel: [color=#ddd]%3d[/color]" % [event.pitch, event.velocity]
		MIDI_MESSAGE_NOTE_ON:
			bb = "[color=gray]Note On    [/color]Note: [color=#ddd]%3d[/color]  Vel: [color=#ddd]%3d[/color]" % [event.pitch, event.velocity]
		MIDI_MESSAGE_AFTERTOUCH:
			bb = "[color=gray]Aftertouch [/color]Note: [color=#ddd]%3d[/color] Pres: [color=#ddd]%3d[/color]" % [event.pitch, event.pressure]
		MIDI_MESSAGE_CONTROL_CHANGE:
			bb = "[color=gray]CControl   [/color]Ctrl: [color=#ddd]%3d[/color]  Val: [color=#ddd]%3d[/color]" % [event.controller_number, event.controller_value]
		MIDI_MESSAGE_PROGRAM_CHANGE:
			bb = "[color=gray]Program:   [/color][color=#ddd]%3d[/color]" % event.instrument
		MIDI_MESSAGE_CHANNEL_PRESSURE:
			bb = "[color=gray]Chnnl Pressure:  [/color][color=#ddd]%3d[/color]" % event.pressure
		MIDI_MESSAGE_PITCH_BEND:
			bb = "[color=gray]Pitch Bend:      [/color][color=#ddd]%5d[/color]" % event.pitch
		_:
			return ""
	return ("[color=dimgray][lb]%02d]  " % (event.channel + 1)) + bb + "[/color]"

func log_midi_event(midi_event: InputEventMIDI) -> void:
	var rep = event_to_BB(midi_event)
	log_lines.push_back(rep)
	if log_lines.size() >= HIGH_LINE:
		log_lines = log_lines.slice(log_lines.size() - LOW_LINE)
		clear()
		append_text("\n".join(log_lines))
	else:
		newline()
		append_text(rep)

func _input(event: InputEvent) -> void:
	if logging and event is InputEventMIDI:
		log_midi_event(event as InputEventMIDI)


func toggle_logging(toggled_on: bool) -> void:
	logging = toggled_on

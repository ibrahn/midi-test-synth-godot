extends VBoxContainer

signal value_changed(value: float)

@onready var ccSpinner := $HBoxContainer/CCNumber
@onready var ccNum: int = ccSpinner.value
@onready var slider := $HBoxContainer/HSlider

func _on_h_slider_value_changed(value: float) -> void:
	value_changed.emit(value)

func _on_cc_number_value_changed(value: float) -> void:
	ccNum = int(value)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_CONTROL_CHANGE and event.controller_number == ccNum:
			slider.value = event.controller_value

func set_value(value: int) -> void:
	slider.value = value

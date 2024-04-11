extends Control

@onready var chorus := AudioServer.get_bus_effect(0, 0)
@onready var filter := AudioServer.get_bus_effect(0, 1)
@onready var reverb := AudioServer.get_bus_effect(0, 2)

func _ready() -> void:
	OS.open_midi_inputs()
	$VSplitContainer/HSplitContainer/PanelContainer/CC/Volume.set_value(62)

func _on_reverb_value_changed(value: float) -> void:
	reverb.wet = 0.5 * value / 127.0

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, (1.0 - value / 127.0) * -60)

func _on_cutoff_value_changed(value: float) -> void:
	filter.cutoff_hz = (800.0 + 2000.0 * value / 127.0)

func _on_chorus_value_changed(value: float) -> void:
	chorus.wet = 0.5 * value / 127.0

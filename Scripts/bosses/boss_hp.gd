extends Node2D

signal no_health

@onready var health_bar = $health_bar

func update_hp(max_value, value):
	health_bar.max_value = max_value
	health_bar.value = value
	if value<1:
		no_health.emit()
		await get_tree().create_timer(2).timeout
		queue_free()

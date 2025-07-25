extends Area2D

signal damaged()

var explosion = preload("res://scenes/effects/explosion.tscn")

func damage():
	damaged.emit()

func explode():
	var e = explosion.instantiate()
	get_tree().root.add_child(e)
	e.start(global_position)
	await e.animation_finished
	queue_free()


func _on_crab_boss_leg_died() -> void:
	explode()

extends PathFollow2D


var speed = 0.05
var active := false

func _process(delta: float) -> void:
	if active:
		progress_ratio += delta * speed

func activate():
	active = true

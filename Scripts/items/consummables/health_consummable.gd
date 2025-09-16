extends Area2D

@export var speed = 60

func start(pos):
	position = pos

func _process(delta):
	position.y += speed * delta


func _on_area_entered(area: Area2D):
	if area.name == "Player":
		speed = 0
		set_deferred("monitoring",false)
		queue_free()
		area.shield += 3


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

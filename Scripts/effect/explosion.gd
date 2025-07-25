extends AnimatedSprite2D

func start(pos):
	position = pos
	await animation_finished
	queue_free()

	

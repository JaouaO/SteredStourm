extends AnimatedSprite2D
@onready var sound = $AudioStreamPlayer
@onready var soundBoss = $AudioStreamPlayer2

func start(pos):
	position = pos
	sound.set_pitch_scale(randf_range(1,1.3))
	sound.play()
	await animation_finished
	queue_free()


func startBoss(pos):
	position = pos
	soundBoss.play()
	await get_tree().create_timer(2).timeout
	queue_free()

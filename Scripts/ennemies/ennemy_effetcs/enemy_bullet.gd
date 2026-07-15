extends Area2D

@onready var sound = $bulletSound
@onready var explosion_sound = $explosionSound


@export var speed = 150
var changed_direction = false

func start(pos):
	position = pos
	sound.set_pitch_scale(randf_range( 1,1.3))
	sound.play()
	changed_direction = false



func _process(delta):
	if changed_direction == true:
		position += transform.x * speed * delta
	else:
		position.y += speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_area_entered(area: Area2D):
	if area.name == "Player":
		speed = 0
		$AnimationPlayer.play("explode")
		explosion_sound.set_pitch_scale(randf_range( 1,1.3))
		explosion_sound.play()
		set_deferred("monitoring",false)
		await  $AnimationPlayer.animation_finished
		queue_free()
		area.shield -= 1
		

func custom_direction():
	changed_direction = true

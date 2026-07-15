extends Area2D
@export var speed = -250
@onready var sound = $AudioStreamPlayer

var explosion = preload("res://scenes/effects/explosion.tscn")

func start(pos):
	position = pos
	sound.set_pitch_scale(randf_range( 1,1.3))
	sound.play()

func _process(delta):
	position.y += speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("ennemies"):
		area.damage()
		add_explosion()
		queue_free()

func add_explosion():
	var e = explosion.instantiate()
	get_tree().root.add_child(e)
	e.scale = Vector2(.5, .5)
	e.start(position)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

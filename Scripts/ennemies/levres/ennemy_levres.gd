extends Area2D

var bullet_scene = preload("res://scenes/ennemies/ennemy_effects/enemy_bullet.tscn")
var explosion = preload("res://scenes/effects/explosion.tscn")

signal died

var start_pos = Vector2.ZERO
var speed = 0
var ScoreValue = 30

@export var health =3
@onready var screensize = get_viewport_rect().size

func start(pos):
	speed=0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	await get_tree().create_timer(randf_range(0.25,0.55)).timeout
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	await tween.finished
	$MoveTimer.wait_time = randf_range(12,30)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(1,5)
	$ShootTimer.start()

func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + 32:
		start(start_pos)

func damage():
	if health>1:
		health -= 1
		"""add_explosion()"""
		return
	speed = 0
	$AnimationPlayer.play("explode")
	set_deferred("monitoring",false)
	died.emit(ScoreValue)
	ScoreValue = 0
	await  $AnimationPlayer.animation_finished
	queue_free()

"""
func add_explosion():
	var e = explosion.instantiate()
	get_tree().root.add_child(e)
	e.scale = Vector2(.5, .5)
	e.start(position)
"""

func _on_move_timer_timeout():
	speed = randf_range(40,60)

 
func _on_shoot_timer_timeout():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	await  get_tree().create_timer(1).timeout
	var c = bullet_scene.instantiate()
	get_tree().root.add_child(c)
	c.start(position)
	$ShootTimer.wait_time = randf_range(1,5)
	$ShootTimer.start()

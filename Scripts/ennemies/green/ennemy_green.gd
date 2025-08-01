extends Area2D

var bullet_scene = preload("res://scenes/ennemies/ennemy_effects/enemy_bullet.tscn")
var heart_scene = preload("res://scenes/items/consummables/health_consummable.tscn")

signal died

var start_pos = Vector2.ZERO
var speed = 0
var ScoreValue = 10

@onready var screensize = get_viewport_rect().size

func start(pos):
	speed=0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	await get_tree().create_timer(randf_range(0.25,0.55)).timeout
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	await tween.finished
	$MoveTimer.wait_time = randf_range(3,10)
	$MoveTimer.start()
	$ShootTimer.wait_time = randf_range(2,8)
	$ShootTimer.start()

func _process(delta):
	position.y += speed * delta
	if position.y > screensize.y + 32:
		start(start_pos)

func damage():
	speed = 0
	$AnimationPlayer.play("explode")
	set_deferred("monitoring",false)
	died.emit(ScoreValue)
	ScoreValue = 0
	await  $AnimationPlayer.animation_finished
	var dropHeart = randf_range(0,100)
	if dropHeart < 5:
		var h = heart_scene.instantiate()
		get_tree().root.add_child(h)
		h.start(position)
	queue_free()


func _on_move_timer_timeout():
	speed = randf_range(50,140)


func _on_shoot_timer_timeout():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	$ShootTimer.wait_time = randf_range(2,8)
	$ShootTimer.start()

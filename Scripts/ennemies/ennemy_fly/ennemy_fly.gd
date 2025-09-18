extends Area2D

var bullet_scene = preload("res://scenes/ennemies/ennemy_effects/enemy_bullet.tscn")
var explosion = preload("res://scenes/effects/explosion.tscn")
var heart_scene = preload("res://scenes/items/consummables/health_consummable.tscn")

signal died

var start_pos = Vector2.ZERO
var move = false
var ScoreValue = 10
var t := 0.0

@onready var screensize = get_viewport_rect().size

func start(pos):
	move = false
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
	if move:
		t += delta
		position.x += sin(t * 3.0) * 100 * delta  # oscillation horizontale
		position.y += 80 * delta

	if position.y > screensize.y + 32:
		start(start_pos)

func damage():
	move = false
	queue_free()
	died.emit(ScoreValue)
	ScoreValue = 10
	var f = explosion.instantiate()
	get_tree().root.add_child(f)
	f.start(position)
	var dropHeart = randf_range(0,100)
	if dropHeart < 5:
		var h = heart_scene.instantiate()
		get_tree().root.add_child(h)
		h.start(position)
	await f.animation_finished



func _on_move_timer_timeout():
	move = true


func _on_shoot_timer_timeout():
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position)
	$ShootTimer.wait_time = randf_range(2,8)
	$ShootTimer.start()

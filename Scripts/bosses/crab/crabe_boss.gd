extends Node2D

signal died

var explosion = preload("res://scenes/effects/explosion.tscn")
var healthBar = preload("res://scenes/bosses/boss_hp.tscn")
@onready var body_player = $crabe_boss_body/AnimationPlayer



var start_pos = Vector2.ZERO
var speed = 0
var scoreValue = 500

@export var maxhp = 100

var hp = maxhp

@onready var screensize = get_viewport_rect().size

var health = healthBar.instantiate()


func damage():
	return


func start(pos):
	health.no_health.connect(_on_boss_hp_no_health)
	get_tree().root.add_child(health)
	speed=0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos
	await get_tree().create_timer(randf_range(0.25,0.55)).timeout
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", start_pos.y, 1.4)
	await tween.finished



func _on_crab_boss_leg_died() -> void:
	hp -=5
	health.update_hp(maxhp, hp)



func _on_crabe_boss_damaged() -> void:
	hp -=1
	health.update_hp(maxhp, hp)



func _on_crab_boss_arm_died() -> void:
	hp -=10
	health.update_hp(maxhp, hp)


func _on_boss_hp_no_health() -> void:
	died.emit(scoreValue)
	var e = explosion.instantiate()
	get_tree().root.add_child(e)
	e.scale = Vector2(3, 3)
	e.start($crabe_boss_body.position)
	await e.animation_finished
	var f = explosion.instantiate()
	get_tree().root.add_child(f)
	f.scale = Vector2(5, 5)
	f.start($crabe_boss_body.position)
	queue_free()

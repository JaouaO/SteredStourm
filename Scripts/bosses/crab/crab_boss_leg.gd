extends Node2D

var explosion = preload("res://scenes/effects/explosion.tscn")
var ennemy_bullet = preload("res://scenes/ennemies/ennemy_effects/enemy_bullet.tscn")
var heart_scene = preload("res://scenes/items/consummables/health_consummable.tscn")


signal damaged()
signal died

var start_pos = Vector2.ZERO
var speed = 0
var ScoreValue = 5

@export var maxhp = 10; 
@onready var screensize = get_viewport_rect().size

var hp = maxhp

func _ready():
	$shoot_timer.wait_time = randf_range(1,10)

func start(pos):
	speed=0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos


func _on_lower_leg_area_damaged() -> void:
	hp -=1
	damaged.emit()
	if hp<1:
		died.emit()
		var dropHeart = randf_range(0,100)
		if dropHeart < 51:
			var h = heart_scene.instantiate()
			get_tree().root.add_child(h)
			h.start(position)
		queue_free()


func _on_upper_leg_area_damaged() -> void:
	hp -=1
	damaged.emit()
	$shoot_timer.start()
	if hp<1:
		died.emit()
		var dropHeart = randf_range(0,100)
		if dropHeart < 51:
			var h = heart_scene.instantiate()
			get_tree().root.add_child(h)
			h.start(position)
		queue_free()


func _on_shoot_timer_timeout() -> void:
	var b = ennemy_bullet.instantiate()
	get_tree().root.add_child(b)
	b.start($Skeleton2D/lower_leg/upper_leg/upper_leg_area.global_position)
	$shoot_timer.wait_time = randf_range(1,10)
	$shoot_timer.start()

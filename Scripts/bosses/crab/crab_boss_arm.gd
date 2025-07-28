extends Node2D

var explosion = preload("res://scenes/effects/explosion.tscn")
var ennemy_bullet = preload("res://scenes/ennemies/ennemy_effects/enemy_bullet.tscn")

signal died
signal damaged

var start_pos = Vector2.ZERO
var speed = 0
var ScoreValue = 5
var max_bullets = 17


@onready var screensize = get_viewport_rect().size
@export var maxhp = 20; 
var hp = maxhp



func start(pos):
	speed=0
	position = Vector2(pos.x, -pos.y)
	start_pos = pos

func shoot():
	$upper_pincer_player.play("pince")
	for i in max_bullets:
		var bullet_instance = ennemy_bullet.instantiate()
		get_tree().root.call_deferred("add_child", bullet_instance)
		bullet_instance.rotation = 20*i
		bullet_instance.start($Skeleton2D/lower_arm/lower_pincer/bullet_origin.global_position)
		bullet_instance.custom_direction()
		await  get_tree().create_timer(.02).timeout





func _on_lower_arm_area_damaged() -> void:
	hp -=1
	damaged.emit()
	if hp<1:
		died.emit()
		queue_free()
		


func _on_lower_pincer_area_damaged() -> void:
	hp -=1
	damaged.emit()
	if hp<1:
		died.emit()
		queue_free()


func _on_upper_pincer_area_damaged() -> void:
	hp -=1
	damaged.emit()
	shoot()
	if hp<1:
		died.emit()
		queue_free()

extends Area2D

var explosion = preload("res://scenes/effects/explosion.tscn")
var ennemy_bullet = preload("res://scenes/ennemies/ennemy_effects/ennemy_long_bullet.tscn")
@onready var player = get_node("/root/Main/Player")

signal damaged


@export var maxhp = 3; 
var hp = maxhp
@onready var exploded = false

func damage():
	damaged.emit()
	hp -= 1
	if hp<1 && not exploded:
		explode()
		exploded = true

func explode():
	var e = explosion.instantiate()
	get_tree().root.add_child(e)
	e.start(global_position)
	$Sprite2D.set_frame(7)


var max_bullets:int= 1
func shoot():
	$iris.look_at(player.position)
	for i in max_bullets:
		var bullet_instance = ennemy_bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.transform = $iris.transform
		bullet_instance.start($iris.global_position)
		bullet_instance.custom_direction()



func _on_shoot_timer_timeout() -> void:
	shoot()
	$shoot_timer.start()

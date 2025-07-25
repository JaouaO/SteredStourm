extends Area2D

signal damaged

var ennemy_bullet = preload("res://scenes/ennemies/ennemy_effects/ennemy_big_bullet.tscn")
var max_bullets = 30
var bullet_delay = .1

func damage():
	damaged.emit()




func shoot():
	$AnimationPlayer.play("open_mouth")
	await $AnimationPlayer.animation_finished
	for i in max_bullets:
		var bullet_instance = ennemy_bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.start(global_position+Vector2(0,-5))
		await  get_tree().create_timer(bullet_delay).timeout
	$AnimationPlayer.play_backwards("open_mouth")
	$shooter_timer.start()



func _on_shooter_timer_timeout() -> void:
	shoot() # Replace with function body.

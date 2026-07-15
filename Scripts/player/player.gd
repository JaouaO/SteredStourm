extends Area2D

signal died
signal shield_changed

@onready var sound = $AudioStreamPlayer
@onready var screensize = get_viewport_rect().size


@export var max_shield = 10
var shield = max_shield:
	set = set_shield

@export var max_speed = 150
@export var cooldown = 0.25
@export var bullet_scene : PackedScene

var can_shoot = true
var alive = true
var speed = max_speed

func _process(delta):
	var input = Input.get_vector("left","right","up","down")
	if input.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
	position += input * speed * delta
	position = position.clamp(Vector2(6,4), screensize - Vector2(6,8))
	if Input.is_action_pressed("shoot"):
		shoot()

func _ready():
	start()
	can_shoot = true

func start():
	$AnimationPlayer.play("RESET")
	position = Vector2(screensize.x/2,screensize.y-64)
	$GunCooldown.wait_time = cooldown
	alive = true
	self.set_collision_layer_value(1,1)
	can_shoot = true
	speed = max_speed

func shoot():
	if not can_shoot || not alive:
		return
	can_shoot = false
	$GunCooldown.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(position + Vector2(0,-8))

func is_alive():
	return alive


func _on_gun_cooldown_timeout():
	can_shoot = true

func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield,shield)
	if shield <= 0 and alive:
		alive = false
		speed = 0
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)

		$AnimationPlayer.play("explode_ship")
		sound.pitch_scale = randf_range(4.0, 5.0)
		sound.play()

		await $AnimationPlayer.animation_finished

		hide()
		died.emit()


func _on_area_entered(area):
	if area.is_in_group("ennemies"):
		area.damage()
		shield -= 4 	

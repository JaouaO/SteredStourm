extends Node2D

@onready var game_over = $CanvasLayer/CenterContainer/GameOver
@onready var start_button = $CanvasLayer/CenterContainer/Start

var enemyYellow = preload("res://scenes/ennemies/yellow/ennemyYellow.tscn")
var enemy_green = preload("res://scenes/ennemies/green/ennemy_green.tscn")
var ennemy_lips = preload("res://scenes/ennemies/levres/ennemy_levres.tscn")
var crabe_boss = preload("res://scenes/bosses/crabe_boss/crabe_boss.tscn")


var score = 0
var lvl = 0

func _ready():
	start_button.show()
	game_over.hide()
#	spawn_ennemies()

func new_game():
	score = 0
	$CanvasLayer/UI.update_score(score)
	$Player.start()
	$Player.show()
	$Player.set_shield(10)
	spawn_ennemies()

func spawn_ennemies():
	
	if lvl >1:
		for x in range(9):
			for y in range(3):
				var d = enemyYellow.instantiate()
				var e = enemy_green.instantiate()
				var f = ennemy_lips.instantiate()
				var pos = Vector2(x*(16+8)+24, 16 * 4 + y * 16)
				var rndm = (randf_range( 0,9) + lvl) 
				
				if rndm < 6:
					add_child(d)
					d.start(pos)
					d.died.connect(_on_enemy_died)
				elif rndm <9:
					add_child(e)
					e.start(pos)
					e.died.connect(_on_enemy_died)
				else:
					add_child(f)
					f.start(pos)
					f.died.connect(_on_enemy_died)
	else:
		var e = crabe_boss.instantiate()
		add_child(e)
		var pos = Vector2(0,-20)
		e.start(pos)
		e.died.connect(_on_enemy_died)

func _on_enemy_died(value):
	score += value
	$CanvasLayer/UI.update_score(score)
	await  get_tree().create_timer(2).timeout
	if get_tree().get_nodes_in_group("ennemies").is_empty() && $Player.is_alive():
		lvl += 1
		spawn_ennemies()


func _on_start_pressed() -> void:
	start_button.hide()   
	new_game()


func _on_player_died() -> void:
	get_tree().call_group("ennemies", "queue_free")
	game_over.show()
	await  get_tree().create_timer(2).timeout
	game_over.hide()
	start_button.show()

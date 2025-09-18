extends Path2D


func start(pos):
	$PathFollow2D/Ennemy_fly.start(pos)
	
signal died


func _on_ennemy_fly_died() -> void:
	died

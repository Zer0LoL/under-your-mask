extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		recoger_pieza()

func recoger_pieza():
	
	var world = get_tree().current_scene 
	if world.has_method("recolectar_pieza"):
		world.recolectar_pieza()
	
	queue_free()

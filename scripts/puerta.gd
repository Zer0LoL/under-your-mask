extends Area2D

@export var destino_marker: Marker2D  
@export var color_zona: Color = Color.WHITE 
@export var esta_bloqueada: bool = false 


@onready var world = get_tree().current_scene 

func _ready():
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") and not esta_bloqueada:
		world.teletransportar(body, destino_marker.global_position, color_zona)

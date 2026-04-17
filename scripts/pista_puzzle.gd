extends Area2D

@onready var dialogo_system = $"../DialogoOverlay" 
var jugador_cerca = false

func _ready():
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		jugador_cerca = true
		

func _on_body_exited(body):
	if body.is_in_group("jugador"):
		jugador_cerca = false

func _input(event):
	if jugador_cerca and event.is_action_pressed("interactuar"):
		
		
		dialogo_system.iniciar_dialogo("pista_inti")

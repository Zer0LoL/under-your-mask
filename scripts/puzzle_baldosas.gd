extends Node2D

@export var mascara_premio: Area2D 
@onready var sfx_correcto = $SFX_Correcto 
@onready var sfx_error = $SFX_Error     

var secuencia_esperada = [1, 2, 3, 4]
var paso_actual = 0 

func _ready():
	
	if mascara_premio:
		mascara_premio.visible = false
		mascara_premio.process_mode = Node.PROCESS_MODE_DISABLED


func pisar_baldosa(id_baldosa):
	
	if paso_actual == -1: return

	
	if id_baldosa == secuencia_esperada[paso_actual]:
		print("Paso correcto: ", id_baldosa)
		paso_actual += 1
		
		if sfx_correcto: sfx_correcto.play()
		
		
		if paso_actual == len(secuencia_esperada):
			puzzle_completado()
	else:
		print("¡Error! Secuencia reiniciada.")
		paso_actual = 0 
		
		if sfx_error: sfx_error.play()

func puzzle_completado():
	print("¡PUZZLE RESUELTO!")
	paso_actual = -1 
	
	
	if mascara_premio:
		mascara_premio.visible = true
		mascara_premio.process_mode = Node.PROCESS_MODE_INHERIT
		
		
		var tween = create_tween()
		mascara_premio.scale = Vector2(0, 0)
		tween.tween_property(mascara_premio, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BOUNCE)


func _on_baldosa_1_nino_body_entered(body):
	if body.is_in_group("jugador"):
		pisar_baldosa(1) 


func _on_baldosa_2_piedra_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		pisar_baldosa(2) 


func _on_baldosa_3_muros_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		pisar_baldosa(3) 


func _on_baldosa_4_rio_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		pisar_baldosa(4) 

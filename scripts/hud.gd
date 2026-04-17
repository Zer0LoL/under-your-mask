extends CanvasLayer

@onready var contenedor = $HBoxContainer
@export var corazon_lleno: Texture2D
@export var corazon_vacio: Texture2D


func actualizar_vidas(vida_actual):

	for i in range(contenedor.get_child_count()):
		var corazon = contenedor.get_child(i)
		
		if i < vida_actual:
			corazon.texture = corazon_lleno
		else:
			corazon.texture = corazon_vacio

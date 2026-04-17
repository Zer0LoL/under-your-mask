extends Control

@export var img_estatua_vacia: Texture2D
@export var img_estatua_completa: Texture2D
@export var img_traidor: Texture2D

@onready var fondo = $ImagenFondo
@onready var capa_negra = $Negro
@onready var capa_flash = $Flash
@onready var creditos = $ContenedorCreditos 
@onready var dialogo = $DialogoOverlay 
@onready var sfx_colocar = $SFX_Colocar
@onready var sfx_flash = $SFX_Flash
@onready var sfx_romper = $SFX_Romper

func _ready():
	creditos.visible = false 
	capa_negra.color = Color.BLACK
	capa_negra.modulate.a = 1.0 
	fondo.texture = img_estatua_vacia
	fondo.position = Vector2.ZERO
	fondo.rotation = 0
	
	await get_tree().create_timer(1.0).timeout
	empezar_secuencia()

func empezar_secuencia():

	var t1 = create_tween()
	t1.tween_property(capa_negra, "modulate:a", 0.0, 2.0)
	await t1.finished
	
	dialogo.iniciar_dialogo("cine_1_estatua")
	await dialogo.dialogo_terminado
	
	sfx_colocar.play()
	fondo.texture = img_estatua_completa
	
	await get_tree().create_timer(1.0).timeout
	
	dialogo.iniciar_dialogo("cine_2_colocada")
	await dialogo.dialogo_terminado
	
	sfx_flash.play()
	capa_flash.modulate.a = 1.0
	capa_negra.modulate.a = 1.0 
	
	var t2 = create_tween()
	t2.tween_property(capa_flash, "modulate:a", 0.0, 3.0)
	
	await get_tree().create_timer(2.0).timeout
	
	dialogo.iniciar_dialogo("cine_3_oscuridad")
	await dialogo.dialogo_terminado
	
	fondo.texture = img_traidor
	
	var t3 = create_tween()
	t3.tween_property(capa_negra, "modulate:a", 0.0, 4.0)
	await t3.finished
	
	dialogo.iniciar_dialogo("cine_4_revelacion")
	await dialogo.dialogo_terminado
	

	dialogo.iniciar_dialogo("cine_5_final")
	

	var t_adios = create_tween()
	t_adios.tween_property(fondo, "modulate", Color(0,0,0,1), 3.0)
	

	var tiempo_temblor = 3.0
	var timer = 0.0
	while timer < tiempo_temblor:
		fondo.position = Vector2(randf_range(-2, 2), randf_range(-2, 2))
		await get_tree().create_timer(0.05).timeout
		timer += 0.05
	
	fondo.position = Vector2.ZERO 
	await dialogo.dialogo_terminado 
	
	
	var t_caida = create_tween()
	t_caida.set_parallel(true)
	t_caida.tween_property(fondo, "rotation_degrees", 180.0, 1.0).set_trans(Tween.TRANS_BACK)
	t_caida.tween_property(fondo, "scale", Vector2(0.1, 0.1), 1.0)
	
	await get_tree().create_timer(0.8).timeout 
	
	sfx_romper.play()
	capa_negra.color = Color.BLACK
	capa_negra.modulate.a = 1.0 
	
	await get_tree().create_timer(2.0).timeout 
	
	creditos.visible = true
	creditos.modulate.a = 0.0 
	
	var t_creditos = create_tween()
	t_creditos.tween_property(creditos, "modulate:a", 1.0, 2.0)

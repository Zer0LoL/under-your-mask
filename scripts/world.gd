extends Node2D

@onready var hud = $HUD
@onready var jugador = $Player
@onready var canvas_modulate = $CanvasModulate
@onready var anim_transicion = $Transicion/AnimationPlayer
@onready var sfx_entrar = $SFX_Entrar  
@onready var sfx_salir = $SFX_Salir   
@onready var dialogo_system = $DialogoOverlay
@onready var music_player = $MusicPlayer
@onready var pieza_boss = $PiezaMascaraBoss 
@onready var boss = $Boss
@onready var puerta_final_visual = $Map/DecorationLayer2
@onready var zona_puerta_final = $ZonaPuertaFinal 
@export var music_lobby: AudioStream
@export var music_combate: AudioStream
@export var music_puzzle: AudioStream
@export var music_boss: AudioStream
var visto_inicio = false
var visto_lobby = false
var visto_combate = false
var visto_puzzle = false
var visto_boss = false
var piezas_recogidas = 0 
func _ready():
	canvas_modulate.color = Color(1, 1, 1, 1)
	dialogo_system.dialogo_terminado.connect(_on_dialogo_terminado)
	cambiar_musica(music_lobby)
	await get_tree().create_timer(1.0).timeout
	if not visto_inicio:
		dialogo_system.iniciar_dialogo("inicio_juego")
		visto_inicio = true
	canvas_modulate.color = Color(1, 1, 1, 1)
	$Transicion/ColorRect.modulate.a = 0
	jugador.vida_cambiada.connect(hud.actualizar_vidas)
	pieza_boss.visible = false
	pieza_boss.process_mode = Node.PROCESS_MODE_DISABLED
func cambiar_musica(nueva_cancion: AudioStream):
	
	if music_player.stream == nueva_cancion and music_player.playing:
		return
	
	
	if music_player.playing:
		
		music_player.stop()
		music_player.stream = nueva_cancion
		music_player.play()
		

	else:
		music_player.stream = nueva_cancion
		music_player.play()
func teletransportar(jugador, nueva_posicion, nuevo_color):
	
	jugador.set_physics_process(false)
	
	
	sfx_entrar.play()
	
	
	
	anim_transicion.play("fade_in_out")
	
	
	await get_tree().create_timer(1.3).timeout
	
	
	
	
	jugador.global_position = nueva_posicion
	canvas_modulate.color = nuevo_color
	
	
	sfx_salir.play()
	
	
	await anim_transicion.animation_finished
	
	
	jugador.set_physics_process(true)


func activar_pieza_boss():
	pieza_boss.visible = true
	pieza_boss.process_mode = Node.PROCESS_MODE_INHERIT
	print("¡La pieza del Boss ha aparecido!")

func recolectar_pieza():
	piezas_recogidas += 1
	print("Piezas recogidas: ", piezas_recogidas, "/ 2")
	
	if piezas_recogidas == 2:
		game_over_victory()
func _on_dialogo_terminado(id):
	if id == "final_completado":
		activar_puerta_final()

func activar_puerta_final():
	print("¡El camino final se ha abierto!")
	
	puerta_final_visual.visible = true
	
	zona_puerta_final.monitoring = true
	
	jugador.set_physics_process(true)
func game_over_victory():
	print("¡JUEGO COMPLETADO!")
	jugador.set_physics_process(false)
	dialogo_system.iniciar_dialogo("final_completado")
func _on_zona_lobby_body_entered(body):
	if body.is_in_group("jugador"):
		
		cambiar_musica(music_lobby) 
		if not visto_lobby and visto_inicio:
			dialogo_system.iniciar_dialogo("entrar_lobby")
			visto_lobby = true

func _on_zona_combate_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_musica(music_combate)
		if not visto_combate:
			dialogo_system.iniciar_dialogo("sala_combate")
			visto_combate = true
			$GestorCombate.iniciar_combate()

func _on_zona_puzzle_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_musica(music_puzzle)
		if not visto_puzzle:
			dialogo_system.iniciar_dialogo("sala_puzzle")
			visto_puzzle = true

func _on_zona_boss_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_musica(music_boss)
		if not visto_boss:
			dialogo_system.iniciar_dialogo("sala_boss")
			visto_boss = true
			
			if is_instance_valid(boss):
				boss.despertar()


func _on_zona_boss_body_exited(body):
	if body.is_in_group("jugador"):
		if is_instance_valid(boss):
			boss.dormir()
			
		cambiar_musica(music_lobby) 


func _on_zona_puerta_final_body_entered(body):
	if body.is_in_group("jugador"):
		ir_a_cinematica()

func ir_a_cinematica():
	jugador.set_physics_process(false)
	
	var cortina = ColorRect.new()
	cortina.color = Color.BLACK
	cortina.size = get_viewport_rect().size
	cortina.modulate.a = 0.0 # Transparente
	
	var canvas = CanvasLayer.new()
	canvas.add_child(cortina)
	add_child(canvas)
	
	var tween = create_tween()
	tween.tween_property(cortina, "modulate:a", 1.0, 1.0)
	
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/CinematicaFinal.tscn")

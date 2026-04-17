extends Node2D

@export var enemigo_scene: PackedScene 
@onready var timer_spawn = $TimerSpawn
@onready var area_spawn = $AreaSpawn

@export var puerta_salida_visual: TileMapLayer 
@export var puerta_trigger: Area2D 

var enemigos_iniciales_totales = 5 
var enemigos_iniciales_muertos = 0 

var limite_oleada_1 = 10
var limite_oleada_2 = 5
var enemigos_spawneados_extra = 0 
var enemigos_muertos_totales = 0 

var combate_iniciado = false

func _ready():
	if puerta_salida_visual: puerta_salida_visual.visible = false 
	if puerta_trigger: puerta_trigger.process_mode = Node.PROCESS_MODE_DISABLED

func iniciar_combate():
	if combate_iniciado: return
	combate_iniciado = true
	print("¡Combate Iniciado! Fase 0: Acaba con los que ves.")
	
	var enemigos_en_escena = get_tree().get_nodes_in_group("enemigos_combate")
	
	enemigos_iniciales_totales = enemigos_en_escena.size()
	
	for enem in enemigos_en_escena:
		if not enem.is_connected("enemigo_muerto", _on_enemigo_muerto):
			enem.enemigo_muerto.connect(_on_enemigo_muerto)
	

func _on_enemigo_muerto():

	if enemigos_iniciales_muertos < enemigos_iniciales_totales:
		enemigos_iniciales_muertos += 1
		enemigos_muertos_totales += 1
		print("Inicial caído. Faltan: ", (enemigos_iniciales_totales - enemigos_iniciales_muertos))
		
		if enemigos_iniciales_muertos >= enemigos_iniciales_totales:
			print("¡Zona despejada! ¡Cuidado, vienen refuerzos!")
			timer_spawn.wait_time = 1.0
			timer_spawn.start() 
			
	else:
		enemigos_muertos_totales += 1
		check_victory()

func _on_timer_spawn_timeout():
	
	if enemigos_spawneados_extra < limite_oleada_1:
		spawnear_enemigo()
		enemigos_spawneados_extra += 1
		
		if enemigos_spawneados_extra == limite_oleada_1:
			print("Fin Oleada 1. Descanso breve y viene la Oleada 2...")
			timer_spawn.wait_time = 2.0 
			
	elif enemigos_spawneados_extra < (limite_oleada_1 + limite_oleada_2):
		spawnear_enemigo()
		enemigos_spawneados_extra += 1
		
	else:
		timer_spawn.stop()
		print("¡Último enemigo spawneado!")

func spawnear_enemigo():
	var nuevo_enem = enemigo_scene.instantiate()
	var x_random = randi_range(0, int(area_spawn.size.x / 16)) * 16
	var y_random = randi_range(0, int(area_spawn.size.y / 16)) * 16
	nuevo_enem.add_to_group("enemigos_combate")
	nuevo_enem.position = area_spawn.position + Vector2(x_random, y_random)
	nuevo_enem.enemigo_muerto.connect(_on_enemigo_muerto)
	get_parent().add_child.call_deferred(nuevo_enem)

func check_victory():
	var total_absoluto = enemigos_iniciales_totales + limite_oleada_1 + limite_oleada_2
	
	print("Progreso Total: ", enemigos_muertos_totales, "/", total_absoluto)
	
	if enemigos_muertos_totales >= total_absoluto:
		victory()

func victory():
	print("¡VICTORIA ABSOLUTA!")
	
	
	if puerta_salida_visual: puerta_salida_visual.visible = true 
	if puerta_trigger: puerta_trigger.process_mode = Node.PROCESS_MODE_INHERIT
	
	
	
	var player = get_tree().get_first_node_in_group("jugador")
	if player:
		player.recuperar_vida_total()

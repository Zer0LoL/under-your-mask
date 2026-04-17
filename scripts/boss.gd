extends CharacterBody2D

signal jefe_derrotado

@export var vida_maxima = 50
var vida_actual = 0

var ultimo_lado = 1 
var duracion_ataque = 2.0
var duracion_base_anim = 2.0 
var fase = 1
var tween_aviso: Tween
var tween_golpe: Tween

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var sfx_smash = $SFX_Smash
@onready var sfx_muerte = $SFX_Muerte

# Zonas
@onready var zona_izq = $ZonasAtaque/ZonaIzquierda
@onready var zona_der = $ZonasAtaque/ZonaDerecha
@onready var color_izq = $ZonasAtaque/ZonaIzquierda/ColorRect
@onready var color_der = $ZonasAtaque/ZonaDerecha/ColorRect
@onready var col_izq = $ZonasAtaque/ZonaIzquierda/CollisionShape2D
@onready var col_der = $ZonasAtaque/ZonaDerecha/CollisionShape2D

var muerto = false
var activo = false

func _ready():
	vida_actual = vida_maxima
	col_izq.disabled = true
	col_der.disabled = true
	
	set_process(false)
	set_physics_process(false)
	activo = false

func despertar():
	if activo or muerto: return
	print("¡EL DIOS HA DESPERTADO!")
	activo = true
	set_process(true)
	set_physics_process(true)
	anim_player.play("idle")
	
	await get_tree().create_timer(1.0).timeout
	ciclo_ataque()

func ciclo_ataque():
	if muerto or not activo: return
	var lado = 0
	if ultimo_lado == 1:
		lado = 0 
	else:
		lado = 1 
		
	ultimo_lado = lado 
	var color_rect = color_izq if lado == 0 else color_der
	var anim_nombre = "ataque_izquierda" if lado == 0 else "ataque_derecha"
	

	var velocidad_playback = duracion_base_anim / duracion_ataque
	
	anim_player.play(anim_nombre, -1, velocidad_playback)
	
	
	tween_aviso = create_tween()
	tween_aviso.tween_property(color_rect, "modulate:a", 0.8, duracion_ataque)
	
	await get_tree().create_timer(duracion_ataque).timeout
	if muerto or not activo: return 
	
	
	sfx_smash.play()
	var col_activa = col_izq if lado == 0 else col_der
	col_activa.disabled = false 
	
	color_rect.modulate.a = 1.0 
	
	
	tween_golpe = create_tween()
	tween_golpe.tween_property(color_rect, "modulate:a", 0.0, 0.3)
	
	await get_tree().create_timer(0.2).timeout
	col_activa.disabled = true
	
	if not activo: return 
	
	anim_player.play("idle")
	
	await get_tree().create_timer(0.5).timeout 
	ciclo_ataque()
func chequear_fase():
	
	if vida_actual <= 35 and fase == 1:
		fase = 2
		duracion_ataque = 1.0
		print("¡FASE 2! Velocidad x2")
	
	
	if vida_actual <= 15 and fase == 2:
		fase = 3
		duracion_ataque = 0.6
		print("¡FASE 3! Velocidad Máxima")


func recibir_dano(cantidad):
	if muerto: return
	vida_actual -= cantidad
	sprite.modulate = Color(10, 0, 0)
	var t = create_tween()
	t.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	chequear_fase()
	if vida_actual <= 0: morir()

func _on_hurtbox_area_entered(area):
	if area.name == "EspadaHitbox": recibir_dano(1)

func morir():
	muerto = true
	activo = false
	sfx_muerte.play()
	col_izq.set_deferred("disabled", true)
	col_der.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(2, 2), 1.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 1.5)
	await tween.finished
	
	if get_parent().has_method("activar_pieza_boss"):
		get_parent().activar_pieza_boss()
	queue_free()

func dormir():
	if not activo: return
	print("El jefe se duerme...")
	activo = false
	
	set_process(false)
	set_physics_process(false)
	
	
	anim_player.stop()
	
	
	if tween_aviso and tween_aviso.is_valid(): tween_aviso.kill()
	if tween_golpe and tween_golpe.is_valid(): tween_golpe.kill()
	
	
	sfx_smash.stop()
	
	
	color_izq.modulate.a = 0.0
	color_der.modulate.a = 0.0
	
	
	col_izq.set_deferred("disabled", true)
	col_der.set_deferred("disabled", true)
func _on_hitbox_cuerpo_body_entered(body):
	if body.is_in_group("jugador"):
		if body.has_method("recibir_dano_jugador"):
			body.recibir_dano_jugador(1, global_position)


func _on_zona_dano_body_entered(body):
	if body.is_in_group("jugador"):
		if body.has_method("recibir_dano_jugador"):
			body.recibir_dano_jugador(1, global_position)


func _on_zona_izquierda_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if body.has_method("recibir_dano_jugador"):
			body.recibir_dano_jugador(1, global_position)

func _on_zona_derecha_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if body.has_method("recibir_dano_jugador"):
			body.recibir_dano_jugador(1, global_position)

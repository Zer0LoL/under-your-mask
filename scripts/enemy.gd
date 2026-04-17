extends CharacterBody2D

# SEÑAL PARA AVISAR AL MUNDO QUE MURIÓ
signal enemigo_muerto 

@export var vida_maxima = 3
var vida_actual = 0

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var sfx_dano = $SFX_Dano
@onready var collision_shape = $CollisionShape2D 
@onready var hurtbox_col = $Hurtbox/CollisionShape2D
@onready var raycast = $RayCast2D 
@onready var timer_mov = $TimerMovimiento 


var tile_size = 16 
var esta_moviendose = false

func _ready():
	vida_actual = vida_maxima
	anim_player.play("idle")
	
	timer_mov.timeout.connect(_on_timer_movimiento_timeout)

func _on_timer_movimiento_timeout():
	if vida_actual <= 0 or esta_moviendose: return
	
	
	var direcciones = [Vector2.ZERO, Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
	var dir_elegida = direcciones.pick_random()
	
	if dir_elegida != Vector2.ZERO:
		mover_en_cuadricula(dir_elegida)
	else:
		
		pass

func mover_en_cuadricula(direccion: Vector2):
	
	raycast.target_position = direccion * tile_size
	raycast.force_raycast_update() 
	
	
	if not raycast.is_colliding():
		esta_moviendose = true
		
		
		var tween = create_tween()
		tween.tween_property(self, "position", position + (direccion * tile_size), 0.3)
		
		
		if direccion.x < 0: sprite.flip_h = true
		elif direccion.x > 0: sprite.flip_h = false
		
		await tween.finished
		esta_moviendose = false


func recibir_dano(cantidad):
	if vida_actual <= 0: return
	vida_actual -= cantidad
	sfx_dano.play()
	
	var tween_golpe = create_tween()
	tween_golpe.tween_property(sprite, "modulate", Color(10, 0, 0), 0.1)
	tween_golpe.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	if vida_actual <= 0:
		morir()

func morir():
	
	emit_signal("enemigo_muerto") 
	
	set_physics_process(false)
	timer_mov.stop() 
	collision_shape.set_deferred("disabled", true)
	hurtbox_col.set_deferred("disabled", true)
	
	var tween_muerte = create_tween()
	tween_muerte.set_parallel(true)
	tween_muerte.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.5)
	tween_muerte.tween_property(sprite, "modulate:a", 0.0, 0.5)
	
	await tween_muerte.finished
	queue_free()

func _on_hurtbox_area_entered(area):
	if area.name == "EspadaHitbox":
		recibir_dano(1)

func _on_hitbox_enemigo_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"): 
		if body.has_method("recibir_dano_jugador"):
			body.recibir_dano_jugador(1, global_position)

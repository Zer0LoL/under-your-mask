extends CharacterBody2D

@export var speed = 65.0

@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var espada_hitbox = $EspadaHitbox 
@onready var sfx_ataque = $SFX_Ataque 
@onready var sfx_dano = $SFX_Dano_Jugador 


enum { MOVE, ATTACK, KNOCKBACK } 
var state = MOVE

var last_direction = Vector2.DOWN
var knockback_vector = Vector2.ZERO 

var vida_maxima = 5 
var vida_actual = 5
var invencible = false 

signal vida_cambiada(vida)

func _ready():
	
	emit_signal("vida_cambiada", vida_actual)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			pass 
		KNOCKBACK:
			knockback_state(delta)

func move_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	if input_vector.x != 0:
		input_vector.y = 0
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
		last_direction = input_vector 
		update_walk_animation(input_vector)
	else:
		velocity = Vector2.ZERO
		update_idle_animation() 

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		iniciar_ataque() 

func iniciar_ataque():
	state = ATTACK
	velocity = Vector2.ZERO
	sfx_ataque.play()
	
	if last_direction.x != 0:
		if last_direction.x > 0:
			anim_player.play("atacar_lado")
			sprite.flip_h = false
		else:
			anim_player.play("atacar_izquierda")
	elif last_direction.y < 0:
		anim_player.play("atacar_arriba")
		sprite.flip_h = false
	else:
		anim_player.play("atacar_abajo")
		sprite.flip_h = false

	await anim_player.animation_finished
	state = MOVE

func knockback_state(delta):
	
	velocity = knockback_vector
	move_and_slide()
	
	
	knockback_vector = knockback_vector.move_toward(Vector2.ZERO, 500 * delta)
	
	
	if knockback_vector.length() < 10:
		state = MOVE
		velocity = Vector2.ZERO

func recibir_dano_jugador(cantidad, posicion_enemigo):
	if invencible: return 
	
	vida_actual -= cantidad
	emit_signal("vida_cambiada", vida_actual) 
	sfx_dano.play()
	
	print("Jugador herido! Vida restante: ", vida_actual)
	
	if vida_actual <= 0:
		get_tree().reload_current_scene()
	else:
		
		var direccion_empuje = (global_position - posicion_enemigo).normalized()
		knockback_vector = direccion_empuje * 150 
		state = KNOCKBACK 
		
		iniciar_invencibilidad()

func iniciar_invencibilidad():
	invencible = true
	var tween = create_tween()
	for i in range(6): 
		tween.tween_property(sprite, "modulate:a", 0.2, 0.1) 
		tween.tween_property(sprite, "modulate:a", 1.0, 0.1) 
	await tween.finished
	invencible = false


func update_walk_animation(vector):
	if vector.y > 0:
		anim_player.play("walk_down")
	elif vector.y < 0:
		anim_player.play("walk_up")
	elif vector.x != 0:
		anim_player.play("walk_side")
		sprite.flip_h = (vector.x > 0) 

func update_idle_animation():
	if last_direction.y > 0:
		anim_player.play("idle_down")
	elif last_direction.y < 0:
		anim_player.play("walk_up")
		anim_player.seek(0, true)
		anim_player.stop()      
	elif last_direction.x != 0:
		anim_player.play("idle_side")
		sprite.flip_h = (last_direction.x > 0)

func recuperar_vida_total():
	vida_actual = vida_maxima
	emit_signal("vida_cambiada", vida_actual) 
	print("¡Bendición recibida! Vida restaurada.")
	
	
	sprite.modulate = Color(0, 1, 0) 
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.5)

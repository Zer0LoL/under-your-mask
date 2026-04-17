extends CanvasLayer

signal dialogo_terminado(id) 

@onready var caja = $Caja
@onready var retrato = $Caja/HBoxContainer/Retrato
@onready var texto_label = $Caja/HBoxContainer/Texto
@onready var sfx_voz = $SFX_Voz
@export var img_hombre: Texture2D
@export var img_mascara: Texture2D
@export var sfx_mascara: AudioStream 
@export var sfx_hombre: AudioStream

var dialogos = {} 
var cola_actual = []
var indice_actual = 0
var esta_activo = false
var escribiendo = false
var id_actual = "" 

func _ready():
	caja.visible = false
	cargar_guiones()

func cargar_guiones():
	
	dialogos = {
		"inicio_juego": [
			{"pj": "H", "txt": "Ya llegamos... este sitio es demasiado anticuado."},
			{"pj": "M", "txt": "Estas ruinas tienen más de mil años escondidas."},
			{"pj": "M", "txt": "Encuentra el resto de mi rostro, y te daré lo que desees como prometí."},
			{"pj": "H", "txt": "No hay trampas... o algo?"},
			{"pj": "M", "txt": "Sigue tu camino, te lo comentaré a su tiempo."},
			{"pj": "H", "txt": "Está bien."}
		],
		"entrar_lobby": [
			{"pj": "H", "txt": "Hmm...  solo veo dos caminos."},
			{"pj": "M", "txt": "Para llegar a nuestro objetivo, debes superar las pruebas colocadas por mis creadores."},
			{"pj": "M", "txt": "Eres libre de decidir cuál será la que afrontes primero."},
			{"pj": "M", "txt": "Según lo que puedo deducir de tu comportamiento, sería mejor que empieces por el desafío de la izquierda."},
			{"pj": "H", "txt": "De nada me servirá buscar tus piezas si muero en el proceso."},
			{"pj": "M", "txt": "No te exaltes."},
			{"pj": "M", "txt": "Eres perfectamente capaz de lograrlo, sé que viniste preparado."},
			{"pj": "H", "txt": "Ugh..."}
		],
		"sala_combate": [
			{"pj": "M", "txt": "Esta zona pondrá a prueba tus habilidades de batalla."},
			{"pj": "M", "txt": "Acaba con los enemigos de mi pasado. Y podremos proseguir."},
			{"pj": "H", "txt": "Quieres que los mate?"},
			{"pj": "M", "txt": "Quiero que sobrevivas al encuentro."},
			{"pj": "H", "txt": ". . ."}
		],
		"sala_puzzle": [
			{"pj": "H", "txt": "Más enemigos??"},
			{"pj": "M", "txt": "No. Esta prueba medirá tu mente."},
			{"pj": "M", "txt": "Debes resolver el acertijo que los dioses prepararon."},
			{"pj": "M", "txt": "Si necesitas ayuda, el monolito relata la historia de esta sala"},
			{"pj": "H", "txt": "Hmm. Debería ser fácil."}
		],
		"sala_boss": [
			{"pj": "M", "txt": "Este es considerado el 'Cuerpo de Dios'."},
			{"pj": "M", "txt": "Será complicado, espero que no te detengas ahora."},
			{"pj": "H", "txt": "No voy a descansar ahora."}
		],
		"pista_inti": [
			{"pj": "H", "txt": "Aquí dice algo..."}, 
			{"pj": "N", "txt": "Cuatro guardianes custodian el camino del Inti."}, 
			{"pj": "N", "txt": "Primero ríe como niño en las fiestas del sol,"},
			{"pj": "N", "txt": "Luego calla con rostro de piedra,"},
			{"pj": "N", "txt": "Después se alzan muros repetidos como las terrazas de Cusco,"},
			{"pj": "N", "txt": "Y al final todo danza, como el río que nunca muere."}
		],
		"final_completado": [
			{"pj": "M", "txt": "Por fin... después de tantos años."},
			{"pj": "M", "txt": "Estoy COMPLETO!!"},
			{"pj": "H", "txt": "Hice lo que me pediste."},
			{"pj": "H", "txt": "Ahora devuélveme mi vida pasada."},
			{"pj": "H", "txt": "Por favor."},
			{"pj": "M", "txt": "Solo queda un último paso para poder cumplir lo que desees."},
			{"pj": "M", "txt": "Se ha abierto la última puerta."},
			{"pj": "M", "txt": "Déjame en el lugar donde pertenezco, por favor."},
			{"pj": "H", "txt": "Es lo último por hacer... Verdad?"},
			{"pj": "M", "txt": "Así es. No hay más después de eso."},
			{"pj": "H", "txt": ". . . "},
			{"pj": "H", "txt": "Está bien."}
		],
		
		"cine_1_estatua": [
			{"pj": "H", "txt": "¿Qué es eso?"},
			{"pj": "M", "txt": "Es... mi hogar. Es donde alguna vez pertenecí."},
			{"pj": "M", "txt": "Colócame, por favor. Y prometo que tu vida no será igual."},
			{"pj": "H", "txt": ". . ."}
		],
		
		"cine_2_colocada": [
			{"pj": "H", "txt": "¿Y ahora? ¿Cómo cumplirás tu parte?"},
			{"pj": "M", "txt": "Ya lo verás."}
		],
		
		"cine_3_oscuridad": [
			{"pj": "M", "txt": ". . ."},
			{"pj": "M", "txt": "¿Qué ha pasado?"},
			{"pj": "M", "txt": "???"},
			{"pj": "M", "txt": "!!!"},
			{"pj": "M", "txt": "¡¿POR QUÉ NO ME PUEDO MOVER?!"}
		],
		
		"cine_4_revelacion": [
			{"pj": "M", "txt": "Qué... ¿QUÉ ME HICISTE?"},
			
			{"pj": "H", "txt": "Jajaja..."}, 
			{"pj": "H", "txt": "JAJAJAJA."},
			{"pj": "H", "txt": "Confiar en un dios no es algo que deberías hacer sin pensarlo bien."},
			{"pj": "M", "txt": "¡NO PUEDES HACERME ESTO!"},
			{"pj": "M", "txt": "YA LO HE PERDIDO TODO, ¡NO PUEDES ARREBATARME MI VIDA TAMBIÉN!"},
			{"pj": "H", "txt": "Lamentablemente, si quería mi libertad, era un precio que ibas a pagar."},
			{"pj": "H", "txt": "Tranquilo, quizá en otros mil años llegue otro ingenuo e intercambies de lugar con él."},
			{"pj": "H", "txt": "Después de todo... ahora ERES una máscara."}
		],
		
		"cine_5_final": [
			{"pj": "M", "txt": "¡¿A DÓNDE VAS?!"},
			{"pj": "M", "txt": "¡AUXILIOOOOOOO!"},
			{"pj": "M", "txt": "¡POR FAVOR, AYUDAAAAAA!"}
		]
	}


func iniciar_dialogo(id_conversacion):
	if id_conversacion in dialogos:
		id_actual = id_conversacion 
		cola_actual = dialogos[id_conversacion]
		indice_actual = 0
		esta_activo = true
		caja.visible = true
		get_tree().paused = true
		mostrar_linea()

func mostrar_linea():
	var datos = cola_actual[indice_actual]
	var personaje = datos.get("pj", "N")
	
	if personaje == "H":
		retrato.visible = true 
		retrato.texture = img_hombre
		sfx_voz.stream = sfx_hombre
	elif personaje == "M":
		retrato.visible = true
		retrato.texture = img_mascara
		sfx_voz.stream = sfx_mascara
	else:
		retrato.visible = false 
		sfx_voz.stream = sfx_hombre 

	texto_label.text = datos["txt"]
	texto_label.visible_characters = 0
	escribiendo = true

	for i in datos["txt"].length():
		if not escribiendo: 
			break 
		texto_label.visible_characters += 1
		if i % 2 == 0: 
			sfx_voz.pitch_scale = randf_range(0.9, 1.1) 
			sfx_voz.play()
		await get_tree().create_timer(0.03).timeout 
		
	escribiendo = false
	texto_label.visible_ratio = 1.0 

func _input(event):
	if not esta_activo: return
	if event.is_action_pressed("ui_accept"):
		if escribiendo:
			escribiendo = false
			texto_label.visible_ratio = 1.0
		else:
			siguiente_linea()

func siguiente_linea():
	indice_actual += 1
	if indice_actual < cola_actual.size():
		mostrar_linea()
	else:
		terminar_dialogo()

func terminar_dialogo():
	esta_activo = false
	caja.visible = false
	get_tree().paused = false
	
	emit_signal("dialogo_terminado", id_actual)

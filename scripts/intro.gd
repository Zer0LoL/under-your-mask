extends Control

@onready var label = $RichTextLabel
@onready var sfx = $AudioStreamPlayer

var pages = [
	"El Imperio Inca no solo forjó oro,\nsino que capturó almas.\nSus máscaras ceremoniales no eran simples adornos,\neran recipientes diseñados para que los dioses\ncaminaran entre los hombres...",
	"O para que los hombres olvidaran quiénes eran.\n\nMuchos siglos después, quedas tú.\nUn hombre que lo perdió todo:\nfamilia, fortuna y dignidad.",
	"Para el mundo, eres un fantasma que camina.\nPara ti mismo, solo un saco de fracasos\ny recuerdos amargos que pesan más que la piedra.",
	"En el corazón de las ruinas prohibidas,\nencontraste un susurro de jade.\nUna mitad rota que te prometió lo imposible:",
	"'Devuélveme mi forma', dijo la reliquia,\n'y yo te devolveré la vida que te arrebataron'.\n\nLa ambición fue más fuerte que el miedo.",
	"Caminas hacia lo profundo,\nbuscando las piezas que faltan para salvarte.\nPero en este lugar, el oro no se regala,\nse intercambia."
]

var current_page = 0
var revealed_chars = 0
var base_speed = 0.05

func _ready():
	label.bbcode_enabled = true 
	label.modulate.a = 0
	label.add_theme_constant_override("line_separation", 10)
	show_page()

func show_page():
	revealed_chars = 0
	label.text = "" 
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	await tween.finished
	
	type_text()

func type_text():
	var full_text = pages[current_page]
	
	while revealed_chars <= full_text.length():
		
		
		
		var visible_part = full_text.left(revealed_chars)
		var invisible_part = full_text.right(full_text.length() - revealed_chars)
		
		
		label.text = "[center]" + visible_part + "[color=#00000000]" + invisible_part + "[/color][/center]"
		
		if revealed_chars > 0:
			var last_char = full_text[revealed_chars - 1]
			if last_char != " " and last_char != "\n":
				sfx.play()
			
			var wait = base_speed
			if last_char == ".": wait = 0.5
			elif last_char == ",": wait = 0.35
			await get_tree().create_timer(wait).timeout
		
		revealed_chars += 1
	
	await get_tree().create_timer(2.5).timeout
	next_page()

func next_page():
	current_page += 1
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	await tween.finished
	
	if current_page < pages.size():
		show_page()
	else:
		get_tree().change_scene_to_file("res://scenes/World.tscn")

extends Node
signal abrir_portal()

export var menu_game_over = "res://Juego/Menus/MenuGameOver.tscn"
export var nivel_actual = ""

var numero_llaves = 0
var contendor_llaves 
onready var nubes_lejanas = $ParallaxBackground/ParallaxNubesLejanas

func _ready():
# warning-ignore:return_value_discarded
	DatosPlayer.connect("game_over", self, "game_over")
	contendor_llaves = get_node_or_null("ZanahoriaLlave")
	if contendor_llaves != null:
		numero_llaves_nivel()
	
func _process(_delta):
	nubes_lejanas.motion_offset.x -= 5	

func numero_llaves_nivel():
	numero_llaves = contendor_llaves.get_child_count()
	DatosPlayer.contabilizar_llaves(numero_llaves)
	for llave in contendor_llaves.get_children():
		llave.connect("consumida", self, "llaves_restantes")

func llaves_restantes():
	numero_llaves -= 1
	if numero_llaves == 0:
		emit_signal("abrir_portal")

func game_over():
	DatosPlayer.nivel_actual = nivel_actual
# warning-ignore:return_value_discarded
	get_tree().change_scene(menu_game_over)

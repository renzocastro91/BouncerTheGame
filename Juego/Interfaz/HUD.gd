extends Control

onready var etiquete_vidas = $ContenedorVida/Cantidad
onready var etiqueta_monedas_oro = $ContenedorMonedaOro/Cantidad 
onready var etiqueta_monedas_plata = $ContenedorMonedaPlata/Cantidad
onready var etiqueta_monedas_bronce = $ContenedorMonedaBronce/Cantidad
onready var etiquete_llaves = $ContenedorLlaves/Cantidad

func _ready():
# warning-ignore:return_value_discarded
	DatosPlayer.connect("actualizar_datos", self, "actualizar_hud")
	$PanelLevel/Level.text = "{p}".format({"p": get_tree().get_current_scene().name})
	actualizar_hud()

func actualizar_hud():
	etiquete_vidas.text = "%s" % DatosPlayer.vidas
	etiqueta_monedas_bronce.text = "%s" % DatosPlayer.monedas_bronce
	etiqueta_monedas_plata.text = "%s" % DatosPlayer.monedas_plata
	etiqueta_monedas_oro.text = "%s" % DatosPlayer.monedas_oro
	etiquete_llaves.text = "%s" % DatosPlayer.llaves
	$PanelPuntaje/Puntaje.text = "Score: {p}".format({"p": DatosPlayer.generar_puntaje()})

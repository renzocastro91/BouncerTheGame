extends Control

func _ready():
	DatosPlayer.reset()

func _on_BotonIniciar_pressed():
	Musica.replay()
	get_tree().change_scene("res://Juego/Niveles/Nivel1.tscn")


func _on_BotonTutorial_pressed():
	Musica.replay()
	get_tree().change_scene("res://Juego/Niveles/NivelTutorial1.tscn")

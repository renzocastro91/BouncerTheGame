extends Area2D

onready var animacion_morir = $AnimationPlayer

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		body.respawn()
	else:
		morir()

func morir():
	animacion_morir.play("morir")
	

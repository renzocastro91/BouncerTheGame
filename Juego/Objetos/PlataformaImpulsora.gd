extends StaticBody2D

onready var animacion = $AnimationPlayer
onready var sfx_impulso = $Salto

func _ready():
	animacion.play("idle")

func _on_DetectorImpulso_body_entered(body):
	sfx_impulso.play()
	animacion.play("impulsar")
	body.impulsar()

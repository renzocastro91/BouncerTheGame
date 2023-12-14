extends Area2D

onready var animacion = $AnimatedSprite
onready var animacion_consumir = $AnimationPlayer
onready var colision_personaje = $CollisionShape2D

func _ready():
	animacion.play()
	


func _on_ItemVida_body_entered(body):
	DatosPlayer.sumar_vida()
	colision_personaje.set_deferred("disabled",true)
	animacion_consumir.play("consumir")

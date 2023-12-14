extends StaticBody2D

var velocidad = 400.0

var mi_posicion = Vector2.ZERO

onready var animacion = $Animacion

func crear(pos,direccion):
	mi_posicion = pos
	velocidad = velocidad * direccion
	if direccion < 0:
		$Animacion.flip_h = true
	else:
		$Animacion.flip_h = false

func _ready():
	global_position = mi_posicion
	animacion.play("moverse")
	
func _process(delta):
	global_position.x += velocidad * delta

func destruirse():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemigos") and body.has_method("morir"):
		body.morir()
	destruirse()



func _on_VisibilityNotifier2D_screen_exited():
	destruirse()


func _on_Timer_timeout():
	destruirse()

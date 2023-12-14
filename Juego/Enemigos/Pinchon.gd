extends KinematicBody2D

export var velocidad = 100.0

var gravedad = 800.0
var movimiento = Vector2.ZERO

onready var animacion = $AnimatedSprite
onready var detector_vacio = $DetectorVacio
onready var detector_pared = $DetectorPared
onready var animacion_morir = $AnimationPlayer
onready var colision_pies = $ColisionPies
onready var colision_cabeza = $DetectorJugador/CollisionPolygon2D
onready var colision_cuerpo = $DetectorJugador/CollisionShape2D

func _physics_process(_delta):
	caer()
	caminar()
# warning-ignore:return_value_discarded
	move_and_slide(movimiento, Vector2.UP)

func caer():
	if not is_on_floor():
		movimiento.y = gravedad
		
		
func caminar():
	if not animacion.is_playing():
		animacion.play("caminar")
		
	detectar_colision()
	movimiento.x = velocidad
	
func detectar_colision():
	if not detector_vacio.is_colliding() or detector_pared.is_colliding():
		velocidad *= -1
		detector_vacio.position *= -1
		detector_pared.scale *= -1
		detector_pared.position.x *= -1
		animar(animacion.flip_h)
	
func animar(valor_actual):
	animacion.flip_h = !valor_actual

func desactivar_colisionadores(colisionadores):
	for colision in colisionadores:
		colision.set_deferred("disabled", true)
		colision.set_deferred("visible", false)	

func _on_DetectorJugador_body_entered(body):
	if body.is_in_group("jugador"):
		body.respawn()
	else:
		desactivar_colisionadores([colision_pies, colision_cabeza, colision_cuerpo])
		morir()

func morir():
	animacion.stop()
	animacion_morir.play("morir")

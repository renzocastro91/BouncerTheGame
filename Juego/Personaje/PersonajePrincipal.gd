extends KinematicBody2D


export var velocidad = Vector2(150.0,150.0)
export var acel_caida = 400
export var fuerza_salto = 3000
export var fuerza_rebote = 350
export var impulso = -3800
export (PackedScene) var bala

var movimiento = Vector2.ZERO
var fuerza_salto_original
var acelearicion_caida_original
var puede_moverse = true
var puede_disparar = true
var saltos_realizados = 0

onready var animacion = $Animacion
onready var audio_salto = $AudioSaltar
onready var camara = $Camera2D
onready var enfriamiento_power_up_salto = $EnfriamientoPowerUpSalto 
onready var enfriamiento_power_up_volar = $EnfriamientoPowerUpVolar
onready var animacion_personaje = $AnimationPlayer
onready var sfx_disparo = $Disparo
onready var posicion_disparo  = $Animacion/PosicionDisparo
onready var cadencia_disparo = $Timer

func _ready():
	animacion_personaje.play("aclarar")
	fuerza_salto_original = fuerza_salto
	acelearicion_caida_original = acel_caida
	cadencia_disparo.wait_time = 1.0
	cadencia_disparo.start()
	
func _process(_delta):
	if puede_disparar and Input.is_action_just_pressed("disparar") and puede_moverse:
		disparar()
		puede_disparar = false
		cadencia_disparo.start()

func _physics_process(_delta):
	movimiento.x = velocidad.x * tomar_direccion()	
	caer()
	saltar()	
	colision_techo()
	caida_al_vacio()
# warning-ignore:return_value_discarded
	move_and_slide(movimiento, Vector2.UP)

func disparar():
	sfx_disparo.play()
	var nueva_bala = bala.instance()
	var direccion_disparo
	if $Animacion.flip_h:
		$Disparos.scale.x = -1
		direccion_disparo = -1	
	else: 
		$Disparos.scale.x = 1
		direccion_disparo = 1
	nueva_bala.crear($Disparos/PosicionDisparo.global_position, direccion_disparo)
	get_parent().add_child(nueva_bala)

func tomar_direccion():
	var direccion = 0
	if puede_moverse:
		direccion = Input.get_action_strength("mov_derecha")-Input.get_action_strength("mov_izquierdo")
		if direccion == 0:
			animacion.play("idle")
		else:
			if direccion < 0:
				animacion.flip_h = true
			else: 
				animacion.flip_h = false
			animacion.play("correr")
	return direccion

func caer():
	if not is_on_floor():		
		animacion.play("saltar")
		movimiento.y += acel_caida
		movimiento.y = clamp(movimiento.y, impulso , velocidad.y)
	else:
		saltos_realizados = 0
		
func saltar():
	if Input.is_action_just_pressed("salto")  and saltos_realizados < 2 and puede_moverse:
		audio_salto.play()
		animacion.play("saltar")
		saltar_movimiento()	
		saltos_realizados += 1
		
func saltar_movimiento():
	movimiento.y = 0
	movimiento.y -= fuerza_salto
	
func colision_techo():
	if is_on_ceiling():
		movimiento.y = fuerza_rebote
		

func impulsar():
	movimiento.y = impulso
	
func cambiar_fuerza_salto():
	enfriamiento_power_up_salto.start()
	fuerza_salto = -impulso * 0.9

func volar():
	enfriamiento_power_up_volar.start()
	acel_caida = 60
	animacion_personaje.play("volar")
	saltar_movimiento()

func caida_al_vacio():
	if position.y > camara.limit_bottom:
		respawn()
				
func respawn():
	DatosPlayer.restar_vidas()
	animacion_personaje.play("oscurecer")
	if DatosPlayer.vidas >= 1:
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	
func _on_EnfriamientoPowerUp_timeout():
	fuerza_salto = fuerza_salto_original


func _on_EnfriamientoPowerUpVolar_timeout():
	animacion_personaje.play("idle")
	acel_caida = acelearicion_caida_original
	
func play_entrar_portal(posicion_portal):
	puede_moverse = false
	animacion_personaje.play("entrar_portal")
	$Tween.interpolate_property(
		self,
		"global_position",
		global_position,
		posicion_portal,
		0.8,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "entrar_portal":
		animacion_personaje.play("oscurecer")


func _on_Timer_timeout():
	puede_disparar = true

extends Area2D

export var es_trampa = false

onready var detector_personaje = $Detector_personaje
var color_trampa = Color.purple

func _ready():
	if es_trampa:
		$Sprite.modulate = color_trampa
		detector_personaje.enabled = true
		rotation_degrees = 180
		
func _process(_delta):
	if detector_personaje.is_colliding():
		detector_personaje.set_deferred("enabled", false)
		$AnimationPlayer.play("caer")

func _on_body_entered(body):
	body.respawn()

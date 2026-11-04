
extends StaticBody2D

var aberta: bool = false

@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func abrir() -> void:
	aberta = true
	colisao.set_deferred("disabled", true)
	sprite.visible = false

func fechar() -> void:
	aberta = false
	colisao.set_deferred("disabled", false)
	sprite.visible = true


extends Area2D

signal portal_utilizado

var ativo: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	desativar()


func ativar() -> void:
	if ativo:
		return

	ativo = true
	sprite.modulate = Color(1, 1, 1, 1)

	print("Portal ativado!")
	print("Estado do portal: ", ativo)

	for corpo in get_overlapping_bodies():
		if corpo.name == "Player":
			print("Player já estava no portal!")
			portal_utilizado.emit()
			break

func desativar() -> void:
	ativo = false

	sprite.modulate = Color(0.3, 0.3, 0.3, 0.5)

	print("Portal desativado!")


func _on_body_entered(body: Node2D) -> void:
	if not ativo:
		return

	if body.name == "Player":
		print("Player entrou no portal!")
		portal_utilizado.emit()

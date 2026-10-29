
@tool
extends StaticBody2D

@export var tamanho: Vector2 = Vector2(128, 128):
	set(valor):
		tamanho = Vector2(
			maxf(valor.x, 16.0),
			maxf(valor.y, 16.0)
		)
		atualizar_parede()

@onready var textura: TextureRect = $Textura
@onready var colisao: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if colisao.shape == null:
		colisao.shape = RectangleShape2D.new()
	else:
		colisao.shape = colisao.shape.duplicate()

	atualizar_parede()

	print("Parede: ", name)
	print("Tamanho da colisão: ", colisao.shape.size)
	print("Collision Layer: ", collision_layer)

func atualizar_parede() -> void:
	if not is_node_ready():
		return

	# Ajusta a textura
	textura.position = -tamanho / 2.0
	textura.size = tamanho
	textura.stretch_mode = TextureRect.STRETCH_TILE

	# Ajusta a colisão
	if colisao.shape is RectangleShape2D:
		colisao.shape.size = tamanho

	colisao.position = Vector2.ZERO
	colisao.disabled = false

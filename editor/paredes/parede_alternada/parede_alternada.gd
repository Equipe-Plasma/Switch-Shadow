
@tool
extends StaticBody2D
@export var textura_player: Texture2D:
	set(valor):
		textura_player = valor
		atualizar_estado()

@export var textura_sombra: Texture2D:
	set(valor):
		textura_sombra = valor
		atualizar_estado()

enum EstadoParede {
	BLOQUEIA_PLAYER,
	BLOQUEIA_SOMBRA
}

@export var estado_atual: EstadoParede = EstadoParede.BLOQUEIA_PLAYER:
	set(valor):
		estado_atual = valor
		atualizar_estado()


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
	if not is_in_group("paredes_alternadas"):
		add_to_group("paredes_alternadas")

	if colisao.shape == null:
		colisao.shape = RectangleShape2D.new()
	else:
		colisao.shape = colisao.shape.duplicate()

	atualizar_parede()
	atualizar_estado()
func alternar_estado() -> void:
	if estado_atual == EstadoParede.BLOQUEIA_PLAYER:
		estado_atual = EstadoParede.BLOQUEIA_SOMBRA
	else:
		estado_atual = EstadoParede.BLOQUEIA_PLAYER

func atualizar_estado() -> void:
	if not is_node_ready():
		return

	match estado_atual:
		EstadoParede.BLOQUEIA_PLAYER:
			set_collision_layer_value(4, true)
			set_collision_layer_value(5, false)

			if textura and textura_player:
				textura.texture = textura_player
				textura.modulate = Color.WHITE

		EstadoParede.BLOQUEIA_SOMBRA:
			set_collision_layer_value(4, false)
			set_collision_layer_value(5, true)

			if textura and textura_sombra:
				textura.texture = textura_sombra
				textura.modulate = Color.WHITE

func atualizar_parede() -> void:
	if not is_node_ready():
		return

	if textura:
		textura.position = -tamanho / 2.0
		textura.size = tamanho
		textura.stretch_mode = TextureRect.STRETCH_TILE

	if colisao and colisao.shape is RectangleShape2D:
		colisao.shape.size = tamanho

	if colisao:
		colisao.position = Vector2.ZERO
		colisao.disabled = false

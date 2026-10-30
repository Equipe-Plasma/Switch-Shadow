@tool
extends StaticBody2D

# Estados possíveis da parede
enum EstadoParede { BLOQUEIA_PLAYER, BLOQUEIA_SOMBRA }

# Estado inicial que você pode escolher direto no Inspetor do Godot
@export var estado_atual: EstadoParede = EstadoParede.BLOQUEIA_PLAYER

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
	# Garante que a parede pertença ao grupo correto para receber o comando de troca
	if not is_in_group("paredes_alternadas"):
		add_to_group("paredes_alternadas")

	# Garante um shape independente e único para cada instância na fase
	if colisao.shape == null:
		colisao.shape = RectangleShape2D.new()
	else:
	
		colisao.shape = colisao.shape.duplicate()

	atualizar_parede()
	atualizar_estado()

# Esta função é chamada automaticamente por todas as paredes quando você aperta ESPAÇO
func alternar_estado() -> void:
	if estado_atual == EstadoParede.BLOQUEIA_PLAYER:
		estado_atual = EstadoParede.BLOQUEIA_SOMBRA
	else:
		estado_atual = EstadoParede.BLOQUEIA_PLAYER
		
	atualizar_estado()

func atualizar_estado() -> void:
	match estado_atual:
		EstadoParede.BLOQUEIA_PLAYER:
			# BLOQUEIA O PLAYER (Layer 4) E DEIXA A SOMBRA PASSAR (Layer 5 desativada)
			set_collision_layer_value(4, true)
			set_collision_layer_value(5, false)
			
			if textura:
				textura.modulate = Color(0.482, 0.494, 1.0, 1.0) # Azul
			
		EstadoParede.BLOQUEIA_SOMBRA:
			# DEIXA O PLAYER PASSAR (Layer 4 desativada) E BLOQUEIA A SOMBRA (Layer 5)
			set_collision_layer_value(4, false)
			set_collision_layer_value(5, true)
			
			if textura:
				textura.modulate = Color(0.616, 0.329, 1.0, 1.0) # Roxo

func atualizar_parede() -> void:
	if not is_node_ready():
		return

	# Ajusta a textura
	if textura:
		textura.position = -tamanho / 2.0
		textura.size = tamanho
		textura.stretch_mode = TextureRect.STRETCH_TILE

	# Ajusta a colisão de forma independente
	if colisao and colisao.shape is RectangleShape2D:
		colisao.shape.size = tamanho

	if colisao:
		colisao.position = Vector2.ZERO
		colisao.disabled = false

extends Area2D

# Estados possíveis da parede
enum EstadoParede { BLOQUEIA_PLAYER, BLOQUEIA_SOMBRA }

# Estado inicial que você pode escolher direto no Inspetor do Godot para cada parede
@export var estado_atual: EstadoParede = EstadoParede.BLOQUEIA_PLAYER

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Atualiza a colisão e a cor assim que a fase começa
	atualizar_estado()

func alternar_estado() -> void:
	# Inverte o estado atual (se era player, vira sombra; se era sombra, vira player)
	if estado_atual == EstadoParede.BLOQUEIA_PLAYER:
		estado_atual = EstadoParede.BLOQUEIA_SOMBRA
	else:
		estado_atual = EstadoParede.BLOQUEIA_PLAYER
		
	# Aplica as mudanças físicas e visuais
	atualizar_estado()

func atualizar_estado() -> void:
	match estado_atual:
		EstadoParede.BLOQUEIA_PLAYER:
			# Bloqueia o Player (Layer 1), deixa a Sombra passar (Layer 2 desativada)
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, false)
			# Cor visual para indicar que bloqueia o Player (ex: Azul)
			sprite.modulate = Color(0.2, 0.4, 1.0, 1.0)
			
		EstadoParede.BLOQUEIA_SOMBRA:
			# Deixa o Player passar (Layer 1 desativada), bloqueia a Sombra (Layer 2)
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, true)
			# Cor visual para indicar que bloqueia a Sombra (ex: Roxo/Rosa)
			sprite.modulate = Color(0.8, 0.2, 0.8, 1.0)

extends StaticBody2D

# Estados possíveis da parede
enum EstadoParede { BLOQUEIA_PLAYER, BLOQUEIA_SOMBRA }

# Estado inicial que você pode escolher direto no Inspetor do Godot
@export var estado_atual: EstadoParede = EstadoParede.BLOQUEIA_PLAYER

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Garante que a parede pertença ao grupo correto para receber o comando de troca
	if not is_in_group("paredes_alternadas"):
		add_to_group("paredes_alternadas")
		
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
			# BLOQUEIA O PLAYER E DEIXA A SOMBRA PASSAR:
			# Ativa a colisão para a layer 4 (bloqueia_player) e desativa para a layer 2 (bloqueia_sombra)
			set_collision_layer_value(4, true)   # Colide/Bloqueia o Player
			set_collision_layer_value(5, false)  # Ignora a Sombra (ela passa livre)
			
			# Cor visual indicando que bloqueia o Player
			sprite.modulate = Color(0.482, 0.494, 1.0, 1.0)
			
		EstadoParede.BLOQUEIA_SOMBRA:
			# BLOQUEIA A SOMBRA E DEIXA O PLAYER PASSAR:
			# Desativa a colisão para a layer 4 (bloqueia_player) e ativa para a layer 2 (bloqueia_sombra)
			set_collision_layer_value(4, false)  # Continua sendo uma parede (Layer 3)
			set_collision_layer_value(5, true)  # Ignora o Player (ele passa livre)
			
			# Cor visual indicando que bloqueia a Sombra
			sprite.modulate = Color(0.616, 0.329, 1.0, 1.0)

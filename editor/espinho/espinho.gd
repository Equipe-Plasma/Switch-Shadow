extends Area2D

# Tipos de alvos que este espinho pode matar e bloquear
enum TipoEspinho { AMBOS, APENAS_PLAYER, APENAS_SOMBRA }

@export var tipo: TipoEspinho = TipoEspinho.AMBOS

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Conecta o sinal de entrada de corpos diretamente na Area2D
	body_entered.connect(_on_body_entered)
	configurar_cor_e_colisao()

func configurar_cor_e_colisao() -> void:
	# Configura quais camadas o espinho vai interagir (Mask)
	# Layer 1 = Player | Layer 2 = Sombra
	match tipo:
		TipoEspinho.AMBOS:
			sprite.modulate = Color(1.0, 1.0, 1.0, 1.0) # Branco
			set_collision_mask_value(1, true)  # Detecta Player
			set_collision_mask_value(2, true)  # Detecta Sombra
			
		TipoEspinho.APENAS_PLAYER:
			sprite.modulate = Color(0.229, 0.243, 1.0, 1.0) # Azul
			set_collision_mask_value(1, true)  # Detecta Player (mata e bloqueia)
			set_collision_mask_value(2, false) # Ignora Sombra (atravessa livre e sem morrer)
			
		TipoEspinho.APENAS_SOMBRA:
			sprite.modulate = Color(0.612, 0.34, 1.0, 1.0) # Roxo
			set_collision_mask_value(1, false) # Ignora Player (atravessa livre e sem morrer)
			set_collision_mask_value(2, true)  # Detecta Sombra (mata e bloqueia)

func _on_body_entered(body: Node2D) -> void:
	# Como a máscara de colisão já filtra quem o espinho enxerga,
	# quem entrar aqui vai acionar a morte correspondente
	if body.name == "Player":
		if tipo == TipoEspinho.AMBOS or tipo == TipoEspinho.APENAS_PLAYER:
			derrota()
	elif body.name == "Sombra" or body.name == "Sombra_reversa":
		if tipo == TipoEspinho.AMBOS or tipo == TipoEspinho.APENAS_SOMBRA:
			derrota()

func derrota() -> void:
	print("Derrota! Mudando para a tela de derrota...")

	var arvore := get_tree()

	if arvore == null:
		return

	arvore.call_deferred(
		"change_scene_to_file",
        "res://menu/telas/tela_derrota/tela_derrota.tscn"
	)

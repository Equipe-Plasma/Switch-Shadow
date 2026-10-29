extends StaticBody2D

# Tipos de alvos que este espinho pode matar
enum TipoEspinho { AMBOS, APENAS_PLAYER, APENAS_SOMBRA }

@export var tipo: TipoEspinho = TipoEspinho.AMBOS

@onready var sprite: Sprite2D = $Sprite2D
@onready var area_dano: Area2D = $AreaDano # Nome da AreaDano que colocamos dentro

func _ready() -> void:
	# Conecta o sinal da área interna de dano
	area_dano.body_entered.connect(_on_body_entered)
	configurar_cor_e_colisao()

func configurar_cor_e_colisao() -> void:
	# Como o StaticBody2D bloqueia tudo por padrão, 
	# configuramos a camada do StaticBody para a Layer de Paredes Gerais (Layer 3)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true) # Colide com Player
	set_collision_mask_value(2, true) # Colide com Sombra

	# Configura a área de dano para escutar apenas o que precisa
	match tipo:
		TipoEspinho.AMBOS:
			sprite.modulate = Color(1.0, 1.0, 1.0, 1.0) # Branco
			area_dano.set_collision_mask_value(1, true)
			area_dano.set_collision_mask_value(2, true)
		TipoEspinho.APENAS_PLAYER:
			sprite.modulate = Color(0.229, 0.243, 1.0, 1.0) # Azul
			area_dano.set_collision_mask_value(1, true)
			area_dano.set_collision_mask_value(2, false)
		TipoEspinho.APENAS_SOMBRA:
			sprite.modulate = Color(0.612, 0.34, 1.0, 1.0) # Roxo
			area_dano.set_collision_mask_value(1, false)
			area_dano.set_collision_mask_value(2, true)

func _on_body_entered(body: Node2D) -> void:
	# Verifica quem encostou na área interna de dano
	if body.name == "Player":
		if tipo == TipoEspinho.AMBOS or tipo == TipoEspinho.APENAS_PLAYER:
			derrota()
	elif body.name == "Sombra":
		if tipo == TipoEspinho.AMBOS or tipo == TipoEspinho.APENAS_SOMBRA:
			derrota()

func derrota() -> void:
	print("Derrota! Mudando para a tela de derrota...")
	call_deferred("_executar_derrota")

func _executar_derrota() -> void:
	get_tree().change_scene_to_file("res://menu/telas/tela_derrota/tela_derrota.tscn")

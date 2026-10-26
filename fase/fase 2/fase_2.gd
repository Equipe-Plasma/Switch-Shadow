extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var sombra: CharacterBody2D = $Sombra

func _unhandled_input(event: InputEvent) -> void:
	# Quando o jogador apertar o botão de troca (ESPAÇO)
	if event.is_action_pressed("trocar_sombra"):
		trocar_posicoes()

func trocar_posicoes() -> void:
	if player == null or sombra == null:
		return
		
	if not pode_trocar_posicoes():
		print("Acão bloqueada:Personagem na parede!! ")
		return

	# Se estiver tudo certo, executa a troca
	realizar_troca()
	
func pode_trocar_posicoes() -> bool:
	# 1. Simula a posição de destino do Player
	var trans_player_destino = player.global_transform
	trans_player_destino.origin = sombra.global_position
	
	# 2. Simula a posição de destino da Sombra
	var trans_sombra_destino = sombra.global_transform
	trans_sombra_destino.origin = player.global_position
	
	# 3. Verifica se algum deles esta na sua parede
	var player_bate = player.test_move(trans_player_destino, Vector2.ZERO)
	var sombra_bate = sombra.test_move(trans_sombra_destino, Vector2.ZERO)
	
	# Retorna verdadeiro apenas se ambos estiverem livres para a troca
	return not (player_bate or sombra_bate)
	
func realizar_troca() -> void:
	# Guardamos temporariamente a posição exata do player
	var pos_temp_player = player.global_position
	
	# O Player vai para a posição da Sombra
	player.global_position = sombra.global_position
	
	# A Sombra vai para onde o Player estava
	sombra.global_position = pos_temp_player

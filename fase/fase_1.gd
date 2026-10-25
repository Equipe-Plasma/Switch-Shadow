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
		
	# Guardamos temporariamente a posição exata do player
	var pos_temp_player = player.global_position
	
	# O Player vai para a posição da Sombra
	player.global_position = sombra.global_position
	
	# A Sombra vai para onde o Player estava
	sombra.global_position = pos_temp_player

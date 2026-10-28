
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var sombra: CharacterBody2D = $Sombra
@onready var botao_pressao = $BotaoPressao
@onready var portal = $PortalSaida

var portal_liberado: bool = false
var fase_concluida: bool = false
# ==========================================
# INICIALIZAÇÃO DA FASE
# ==========================================
func _ready() -> void:
	print("=== INICIANDO FASE 2 ===")

	Global.registrar_fase(scene_file_path)

	print("Botão encontrado: ", botao_pressao)
	print("Portal encontrado: ", portal)

	portal.desativar()

	if not botao_pressao.estado_alterado.is_connected(_on_estado_botao_alterado):
		botao_pressao.estado_alterado.connect(_on_estado_botao_alterado)

	print("Sinal conectado: ",
		botao_pressao.estado_alterado.is_connected(_on_estado_botao_alterado)
	)

	if not portal.portal_utilizado.is_connected(avancar_para_proxima_fase):
		portal.portal_utilizado.connect(avancar_para_proxima_fase)

	print("=== FASE 2 PRONTA ===")
# ==========================================
# TROCA DE POSIÇÕES
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("trocar_sombra"):
		trocar_posicoes()


func trocar_posicoes() -> void:
	if player == null or sombra == null:
		return

	if not pode_trocar_posicoes():
		print("Ação bloqueada: personagem na parede!")
		return

	realizar_troca()


func pode_trocar_posicoes() -> bool:
	# Simula o Player na posição da Sombra
	var trans_player_destino = player.global_transform
	trans_player_destino.origin = sombra.global_position

	# Simula a Sombra na posição do Player
	var trans_sombra_destino = sombra.global_transform
	trans_sombra_destino.origin = player.global_position

	# Verifica colisões nos destinos
	var player_bate = player.test_move(
		trans_player_destino,
		Vector2.ZERO
	)

	var sombra_bate = sombra.test_move(
		trans_sombra_destino,
		Vector2.ZERO
	)

	return not (player_bate or sombra_bate)


func realizar_troca() -> void:
	var pos_temp_player = player.global_position

	player.global_position = sombra.global_position
	sombra.global_position = pos_temp_player

	print("Posições trocadas!")


# ==========================================
# BOTÃO DE PRESSÃO
# ==========================================
func _on_estado_botao_alterado(pressionado: bool) -> void:
	print("Fase 2 recebeu sinal: ", pressionado)

	if pressionado:
		portal_liberado = true
		portal.ativar()
		print("Portal liberado!")
	else:
		portal_liberado = false
		portal.desativar()
		print("Portal bloqueado!")
# ==========================================
# CONCLUSÃO DA FASE
# ==========================================

func avancar_para_proxima_fase() -> void:
	if fase_concluida:
		return

	if not portal_liberado:
		return

	fase_concluida = true

	print("Player entrou no portal!")
	print("Fase 2 concluída!")

	get_tree().call_deferred(
		"change_scene_to_file",
        "res://telas/tela_vitoria/tela_vitoria.tscn"
	)


extends Node2D

# ==========================================
# REFERÊNCIAS
# ==========================================

@onready var player: CharacterBody2D = $Player
@onready var sombra: CharacterBody2D = $Sombra
@onready var portal = $PortalSaida

var portal_liberado: bool = false
var fase_concluida: bool = false

var itens_coletados: int = 0
var total_itens: int = 0


# ==========================================
# INICIALIZAÇÃO DA FASE 2
# ==========================================

func _ready() -> void:
	print("=== INICIANDO FASE 2 ===")

	Global.registrar_fase(scene_file_path)

	if not portal.portal_utilizado.is_connected(avancar_para_proxima_fase):
		portal.portal_utilizado.connect(avancar_para_proxima_fase)

	configurar_itens()

	print("=== FASE 2 PRONTA ===")


# ==========================================
# SISTEMA DE ITENS
# ==========================================

func configurar_itens() -> void:
	itens_coletados = 0

	var itens_da_fase: Array[Node] = []

	for filho in get_children():
		if filho.name == "Item" or filho.name.begins_with("Item"):
			if filho is Area2D:
				itens_da_fase.append(filho)

	total_itens = itens_da_fase.size()

	for item in itens_da_fase:
		item.tree_exiting.connect(_on_item_coletado)

	print("Total de itens da Fase 2: ", total_itens)

	if total_itens == 0:
		push_warning("Nenhum item encontrado na Fase 2!")


func _on_item_coletado() -> void:
	itens_coletados += 1

	print(
		"Itens coletados: ",
		itens_coletados,
		"/",
		total_itens
	)

	if itens_coletados >= total_itens and total_itens > 0:
		liberar_portal()


# ==========================================
# ATIVAÇÃO DO PORTAL
# ==========================================

func liberar_portal() -> void:
	if portal_liberado:
		return

	portal_liberado = true
	portal.ativar()

	print("Todos os itens coletados!")
	print("Portal da Fase 2 liberado!")


# ==========================================
# TROCA DE POSIÇÕES
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("trocar_sombra"):
		if event is InputEventKey and event.is_echo():
			return

		trocar_posicoes()


func trocar_posicoes() -> void:
	if player == null or sombra == null:
		return

	if not pode_trocar_posicoes():
		print("Ação bloqueada: personagem na parede!")
		return

	realizar_troca()


func pode_trocar_posicoes() -> bool:
	var trans_player_destino = player.global_transform
	trans_player_destino.origin = sombra.global_position

	var trans_sombra_destino = sombra.global_transform
	trans_sombra_destino.origin = player.global_position

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
	# O botão não controla mais o portal.
	# Mantemos a função para não quebrar
	# conexões de sinais existentes.
	print("Botão pressionado: ", pressionado)


# ==========================================
# CONCLUSÃO DA FASE
# ==========================================

func avancar_para_proxima_fase() -> void:
	if fase_concluida:
		return

	if not portal_liberado:
		print("Portal bloqueado: faltam itens!")
		return

	fase_concluida = true

	print("Player entrou no portal!")
	print("Fase 2 concluída!")
	print("Abrindo tela de vitória...")

	var caminho_vitoria := "res://menu/telas/tela_vitoria/tela_vitoria.tscn"

	if not ResourceLoader.exists(caminho_vitoria):
		push_error("Tela de vitória não encontrada: " + caminho_vitoria)
		fase_concluida = false
		return

	get_tree().call_deferred(
		"change_scene_to_file",
		caminho_vitoria
	)

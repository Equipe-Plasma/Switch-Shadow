
extends Node2D

# ==========================================
# REFERÊNCIAS
# ==========================================

@onready var player: CharacterBody2D = $Player
@onready var sombra: CharacterBody2D = $Sombra_reversa
@onready var portal_saida: Area2D = $PortalSaida
@onready var trocar: AudioStreamPlayer = $Player/Trocar

var portal_liberado: bool = false
var fase_concluida: bool = false

@onready var itens: Array[Node] = [
	$Item,
	$Item2,
	$Item3
]

var troca_em_andamento: bool = false

var itens_coletados: int = 0
var total_itens: int = 0

# ==========================================
# INICIALIZAÇÃO DA FASE 3
# ==========================================
func _ready() -> void:
	Global.registrar_fase(scene_file_path)
	Global.ultima_fase = scene_file_path

	configurar_itens()

	if not portal_saida.portal_utilizado.is_connected(avancar_para_proxima_fase):
		portal_saida.portal_utilizado.connect(avancar_para_proxima_fase)

	print("=== FASE 3 INICIADA ===")

# ==========================================
# SISTEMA DE ITENS E PORTAL
# ==========================================
func configurar_itens() -> void:
	itens_coletados = 0
	total_itens = itens.size()

	for item in itens:
		item.tree_exiting.connect(_on_item_coletado)

	print("Total de itens: ", total_itens)


func _on_item_coletado() -> void:
	itens_coletados += 1

	print(
		"Itens coletados: ",
		itens_coletados,
		"/",
		total_itens
	)

	if itens_coletados == total_itens:
		ativar_portal()


func ativar_portal() -> void:
	if portal_liberado:
		return

	if not is_instance_valid(portal_saida):
		push_error("PortalSaida não encontrado!")
		return

	if portal_saida.has_method("ativar"):
		portal_saida.ativar()
		portal_liberado = true

		print("Todos os itens foram coletados!")
		print("Portal da Fase 3 liberado!")
	else:
		push_error("PortalSaida não possui o método ativar()!")
# ==========================================
# CONTROLE DO TECLADO
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("trocar_sombra"):
		if event is InputEventKey and event.is_echo():
			return

		trocar_posicoes()
		if trocar:
			trocar.play()

# ==========================================
# SOLICITAR TROCA
# ==========================================
func trocar_posicoes() -> void:
	if troca_em_andamento:
		return

	if not is_instance_valid(player):
		return

	if not is_instance_valid(sombra):
		return

	troca_em_andamento = true

	# Aguarda o próximo momento seguro
	# para verificar colisões e trocar posições.
	realizar_troca_segura.call_deferred()


# ==========================================
# EXECUTAR TROCA SEGURA
# ==========================================
func realizar_troca_segura() -> void:
	if not pode_trocar_posicoes():
		print("Troca bloqueada: destino ocupado!")
		troca_em_andamento = false
		return

	var pos_player: Vector2 = player.global_position
	var pos_sombra: Vector2 = sombra.global_position

	print("================================")
	print("ANTES DA TROCA")
	print("Player: ", pos_player)
	print("Sombra: ", pos_sombra)

	# Interrompe velocidades anteriores
	player.velocity = Vector2.ZERO
	sombra.velocity = Vector2.ZERO

	# Troca exatamente as posições globais
	player.global_position = pos_sombra
	sombra.global_position = pos_player

	# Atualiza as transformações físicas
	player.force_update_transform()
	sombra.force_update_transform()

	print("DEPOIS DA TROCA")
	print("Player: ", player.global_position)
	print("Sombra: ", sombra.global_position)
	print("================================")

	troca_em_andamento = false


# ==========================================
# VERIFICAR SE A TROCA É POSSÍVEL
# ==========================================

func pode_trocar_posicoes() -> bool:
	var pos_player: Vector2 = player.global_position
	var pos_sombra: Vector2 = sombra.global_position

	# Verifica se o Player cabe na posição da Sombra
	var player_bate: bool = destino_bloqueado(
		player,
		pos_sombra
	)

	# Verifica se a Sombra cabe na posição do Player
	var sombra_bate: bool = destino_bloqueado(
		sombra,
		pos_player
	)

	print("Colisão Player: ", player_bate)
	print("Colisão Sombra: ", sombra_bate)

	return not player_bate and not sombra_bate


# ==========================================
# VERIFICAR COLISÃO NO DESTINO
# ==========================================

func destino_bloqueado(
	personagem: CharacterBody2D,
	destino: Vector2
) -> bool:

	var colisao: CollisionShape2D = personagem.get_node(
        "CollisionShape2D"
	)

	if colisao.shape == null:
		return true

	var parametros = PhysicsShapeQueryParameters2D.new()

	parametros.shape = colisao.shape

	# Usa a transformação real da colisão no destino
	var transform_destino: Transform2D = personagem.global_transform
	transform_destino.origin = destino

	parametros.transform = (
		transform_destino * colisao.transform
	)

	# Verifica apenas as camadas que o personagem detecta
	parametros.collision_mask = personagem.collision_mask

	# Ignora os dois personagens
	parametros.exclude = [
		player.get_rid(),
		sombra.get_rid()
	]

	parametros.margin = 0.0

	var espaco = get_world_2d().direct_space_state

	var resultados = espaco.intersect_shape(
		parametros,
		32
	)

	return not resultados.is_empty()


func _on_portal_saida_body_entered(body: Node2D) -> void:
	if body != player:
		return

	if itens_coletados < total_itens:
		print("Portal bloqueado: faltam itens!")
		return

	print("Player entrou no portal!")
	print("Todos os itens coletados!")


# ==========================================
# CONCLUSÃO DA FASE 3
# ==========================================

func avancar_para_proxima_fase() -> void:
	if fase_concluida:
		return

	if not portal_liberado:
		print("Portal bloqueado: faltam itens!")
		return

	fase_concluida = true

	print("Player entrou no portal!")
	print("Fase 3 concluída!")
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

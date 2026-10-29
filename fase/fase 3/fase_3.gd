
extends Node2D

# ==========================================
# REFERÊNCIAS
# ==========================================

@onready var player: CharacterBody2D = $Player
@onready var sombra: CharacterBody2D = $Sombra

var troca_em_andamento: bool = false


# ==========================================
# INICIALIZAÇÃO DA FASE 3
# ==========================================

func _ready() -> void:
	Global.registrar_fase(scene_file_path)
	Global.ultima_fase = scene_file_path

	print("=== FASE 3 INICIADA ===")


# ==========================================
# CONTROLE DO TECLADO
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("trocar_sombra"):
		if event is InputEventKey and event.is_echo():
			return

		trocar_posicoes()


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

	# Aguarda o próximo ciclo físico para
	# verificar colisões e trocar posições.
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
	var player_bate = destino_bloqueado(
		player,
		pos_sombra
	)

	# Verifica se a Sombra cabe na posição do Player
	var sombra_bate = destino_bloqueado(
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

	var colisao = personagem.get_node("CollisionShape2D")

	if colisao.shape == null:
		return true

	var parametros = PhysicsShapeQueryParameters2D.new()

	parametros.shape = colisao.shape

	# Usa a transformação real da colisão no destino
	var transform_destino = personagem.global_transform
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

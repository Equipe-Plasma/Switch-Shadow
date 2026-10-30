extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var sombra: CharacterBody2D = $Sombra_reversa
@onready var portal = $PortalSaida

var total_itens: int = 0
var fase_concluida: bool = false

func _ready() -> void:
	Global.registrar_fase(scene_file_path)
	# Salva o caminho desta fase no nosso script global
	Global.ultima_fase = scene_file_path
	portal.portal_utilizado.connect(avancar_para_proxima_fase)
	
	# Conta quantos itens existem na fase ao iniciar com base no grupo "itens"
	total_itens = get_tree().get_nodes_in_group("itens").size()
	print("Itens totais nesta fase: ", total_itens)

func _process(_delta: float) -> void:
	verificar_progresso()

func _unhandled_input(event: InputEvent) -> void:
	# Quando o jogador apertar o botão de troca (ESPAÇO)
	if event.is_action_pressed("trocar_sombra"):
		trocar_posicoes()
		
	# Atalho para avançar de fase ao apertar Enter (ui_accept) ou a ação configurada
	if event.is_action_pressed("proxima_fase"):
		avancar_para_proxima_fase()
	# TEm q apagar isso dps ^

func trocar_posicoes() -> void:
	if player == null or sombra == null:
		return
		
	if not pode_trocar_posicoes():
		print("Ação bloqueada: Personagem na parede!! ")
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
	
	# 2. NOVO: Pede para todas as paredes do grupo "paredes_alternadas" mudarem de estado!
	get_tree().call_group("paredes_alternadas", "alternar_estado")


func verificar_progresso() -> void:
	# Verifica quantos itens ainda existem na fase
	var itens_restantes = get_tree().get_nodes_in_group("itens").size()

	# Quando todos os itens forem coletados
	if total_itens > 0 and itens_restantes == 0:
		portal.ativar()
		print("Todos os itens coletados! Portal ativado!")

func avancar_para_proxima_fase() -> void:
	if fase_concluida:
		return

	fase_concluida = true

	print("Player entrou no portal! Fase concluída!")

	get_tree().call_deferred(
		"change_scene_to_file",
        "res://menu/telas/tela_vitoria/tela_vitoria.tscn"
	)

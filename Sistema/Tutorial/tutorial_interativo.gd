
extends CanvasLayer

# Etapas do tutorial
enum Etapa {
	MOVIMENTACAO,
	TROCA,
	COLETA,
	PORTAL,
	FINALIZADO
}

var etapa_atual: Etapa = Etapa.MOVIMENTACAO

# Distância necessária para considerar que a sombra
# atravessou a parede inicial.
@export var limite_x_sombra: float = 380.0

# Referências da fase
@onready var fase = get_parent()
@onready var player: CharacterBody2D = fase.get_node("Player")
@onready var sombra: CharacterBody2D = fase.get_node("Sombra")
@onready var portal = fase.get_node("PortalSaida")

# Interface
var painel: PanelContainer
var texto: Label
var botao_pular: Button

# Quantidade inicial de itens
var total_itens: int = 0

var tutorial_encerrado: bool = false


func _ready() -> void:

	# Permite que o tutorial continue funcionando
	# mesmo se o jogo estiver pausado.
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Conta os itens existentes na fase.
	total_itens = get_tree().get_nodes_in_group("itens").size()

	# Conecta o sinal de troca da fase.
	if not fase.troca_realizada.is_connected(_on_troca_realizada):
		fase.troca_realizada.connect(_on_troca_realizada)

	# Conecta o sinal de entrada no portal.
	if not portal.portal_utilizado.is_connected(_on_portal_utilizado):
		portal.portal_utilizado.connect(_on_portal_utilizado)

	_criar_interface()
	_atualizar_tutorial()


func _process(_delta: float) -> void:

	if tutorial_encerrado:
		return

	match etapa_atual:

		# ETAPA 1: MOVIMENTAÇÃO
		Etapa.MOVIMENTACAO:

			# A sombra precisa atravessar a parede inicial.
			if sombra.global_position.x >= limite_x_sombra:
				_avancar_etapa()


		# ETAPA 2: TROCA
		Etapa.TROCA:

			pass


		# ETAPA 3: COLETA
		Etapa.COLETA:

			var itens_restantes = get_tree().get_nodes_in_group("itens").size()

			# Só avança quando TODOS os itens forem coletados.
			if itens_restantes == 0 and total_itens > 0:
				_avancar_etapa()


		# ETAPA 4: PORTAL
		Etapa.PORTAL:

			pass


func _criar_interface() -> void:

	# Painel principal
	painel = PanelContainer.new()

	# Posicionamento da janela
	painel.anchor_left = 0.15
	painel.anchor_right = 0.85

	painel.anchor_top = 1.0
	painel.anchor_bottom = 1.0

	painel.offset_top = -165
	painel.offset_bottom = -25
	

	# Aparência
	var estilo = StyleBoxFlat.new()

	estilo.bg_color = Color(0.08, 0.08, 0.12, 0.94)
	estilo.set_corner_radius_all(12)
	estilo.set_content_margin_all(16)

	painel.add_theme_stylebox_override("panel", estilo)

	add_child(painel)

	# Organização vertical
	var organizacao = VBoxContainer.new()

	painel.add_child(organizacao)

	# Texto
	texto = Label.new()

	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.custom_minimum_size = Vector2(0, 65)

	texto.add_theme_font_size_override("font_size", 20)

	organizacao.add_child(texto)

	# Botão de pular
	botao_pular = Button.new()

	botao_pular.text = "Pular tutorial"
	botao_pular.pressed.connect(_pular_tutorial)

	organizacao.add_child(botao_pular)


func _atualizar_tutorial() -> void:

	match etapa_atual:

		Etapa.MOVIMENTACAO:

			texto.text = "MOVIMENTAÇÃO\nUse W, A, S, D ou as SETAS DIRECIONAIS para movimentar os personagens. Observe que apenas a sombra consegue atravessar esta parede."


		Etapa.TROCA:

			texto.text = "TROCA DE POSIÇÕES\nAgora pressione ESPAÇO para trocar de posição com sua sombra e conseguir atravessar a parede."


		Etapa.COLETA:

			texto.text = "COLETA DE ITENS\nColete TODOS os itens espalhados pela fase. Você precisará de todos para desbloquear o portal."


		Etapa.PORTAL:

			texto.text = "OBJETIVO FINAL\nMuito bem! Todos os itens foram coletados. O portal está desbloqueado. Encontre-o para concluir a fase."


		Etapa.FINALIZADO:

			texto.text = "Tutorial concluído!"


func _avancar_etapa() -> void:

	if etapa_atual == Etapa.FINALIZADO:
		return

	etapa_atual += 1

	_atualizar_tutorial()


func _on_troca_realizada() -> void:

	# Só aceita a troca quando o jogador estiver
	# na etapa correta do tutorial.
	if etapa_atual == Etapa.TROCA:
		_avancar_etapa()


func _on_portal_utilizado() -> void:

	if etapa_atual == Etapa.PORTAL:
		_encerrar_tutorial()


func _pular_tutorial() -> void:

	_encerrar_tutorial()


func _encerrar_tutorial() -> void:

	tutorial_encerrado = true

	etapa_atual = Etapa.FINALIZADO

	painel.hide()

	print("Tutorial concluído!")

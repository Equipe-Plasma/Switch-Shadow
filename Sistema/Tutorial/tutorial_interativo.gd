
extends CanvasLayer

# ==========================================
# ETAPAS DO TUTORIAL
# ==========================================

enum Etapa {
	MOVIMENTACAO,
	TROCA,
	COLETA,
	PORTAL,
	FINALIZADO
}

var etapa_atual: Etapa = Etapa.MOVIMENTACAO

@export var limite_x_sombra: float = 380.0


# ==========================================
# REFERÊNCIAS
# ==========================================

@onready var fase = get_parent()
@onready var player: CharacterBody2D = fase.get_node("Player")
@onready var sombra: CharacterBody2D = fase.get_node("Sombra")
@onready var portal = fase.get_node("PortalSaida")


# ==========================================
# INTERFACE E CONTROLE
# ==========================================

var painel: PanelContainer
var texto: Label
var botao_pular: Button

var total_itens: int = 0
var tutorial_encerrado: bool = false


# ==========================================
# INICIALIZAÇÃO
# ==========================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	total_itens = get_tree().get_nodes_in_group("itens").size()

	if not fase.troca_realizada.is_connected(_on_troca_realizada):
		fase.troca_realizada.connect(_on_troca_realizada)

	if not portal.portal_utilizado.is_connected(_on_portal_utilizado):
		portal.portal_utilizado.connect(_on_portal_utilizado)

	_criar_interface()
	_atualizar_tutorial()


# ==========================================
# PROCESSAMENTO DAS ETAPAS
# ==========================================

func _process(_delta: float) -> void:
	if tutorial_encerrado:
		return

	match etapa_atual:
		Etapa.MOVIMENTACAO:
			if sombra.global_position.x >= limite_x_sombra:
				_avancar_etapa()

		Etapa.TROCA:
			pass

		Etapa.COLETA:
			var itens_restantes = get_tree().get_nodes_in_group("itens").size()

			if itens_restantes == 0 and total_itens > 0:
				_avancar_etapa()

		Etapa.PORTAL:
			pass


# ==========================================
# CRIAÇÃO DA INTERFACE
# ==========================================

func _criar_interface() -> void:
	painel = PanelContainer.new()

	painel.anchor_left = 0.15
	painel.anchor_right = 0.85
	painel.anchor_top = 1.0
	painel.anchor_bottom = 1.0

	painel.offset_top = -165
	painel.offset_bottom = -25

	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0.08, 0.08, 0.12, 0.94)
	estilo.set_corner_radius_all(12)
	estilo.set_content_margin_all(16)

	painel.add_theme_stylebox_override("panel", estilo)
	add_child(painel)

	var organizacao = VBoxContainer.new()
	painel.add_child(organizacao)

	# Texto do tutorial
	texto = Label.new()
	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.custom_minimum_size = Vector2(0, 65)
	texto.add_theme_font_size_override("font_size", 20)

	# O texto será traduzido manualmente com tr().
	texto.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED

	organizacao.add_child(texto)

	# Botão de pular tutorial
	botao_pular = Button.new()
	botao_pular.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	botao_pular.text = _traduzir("TUTORIAL_PULAR")
	botao_pular.pressed.connect(_pular_tutorial)

	organizacao.add_child(botao_pular)


# ==========================================
# SISTEMA DE TRADUÇÃO
# ==========================================

func _traduzir(chave: String) -> String:
	# Converte o \n escrito no CSV em quebra de linha.
	return tr(chave).replace("\\n", "\n")


func _atualizar_tutorial() -> void:
	if texto == null:
		return

	match etapa_atual:
		Etapa.MOVIMENTACAO:
			texto.text = _traduzir("TUTORIAL_MOVIMENTACAO")

		Etapa.TROCA:
			texto.text = _traduzir("TUTORIAL_TROCA")

		Etapa.COLETA:
			texto.text = _traduzir("TUTORIAL_COLETA")

		Etapa.PORTAL:
			texto.text = _traduzir("TUTORIAL_PORTAL")

		Etapa.FINALIZADO:
			texto.text = _traduzir("TUTORIAL_FINALIZADO")


# ==========================================
# AVANÇAR ETAPA
# ==========================================

func _avancar_etapa() -> void:
	if etapa_atual == Etapa.FINALIZADO:
		return

	etapa_atual += 1
	_atualizar_tutorial()


# ==========================================
# TROCA DE POSIÇÕES
# ==========================================

func _on_troca_realizada() -> void:
	if etapa_atual == Etapa.TROCA:
		_avancar_etapa()


# ==========================================
# ENTRADA NO PORTAL
# ==========================================

func _on_portal_utilizado() -> void:
	if etapa_atual == Etapa.PORTAL:
		_encerrar_tutorial()


# ==========================================
# PULAR TUTORIAL
# ==========================================

func _pular_tutorial() -> void:
	_encerrar_tutorial()


# ==========================================
# ENCERRAMENTO
# ==========================================

func _encerrar_tutorial() -> void:
	if tutorial_encerrado:
		return

	tutorial_encerrado = true
	etapa_atual = Etapa.FINALIZADO

	painel.hide()

	print(_traduzir("TUTORIAL_FINALIZADO"))

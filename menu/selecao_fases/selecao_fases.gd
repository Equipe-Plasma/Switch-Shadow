
extends Control

const MENU_PRINCIPAL = "res://menu/menu_principal/menu_principal.tscn"

const TOTAL_FASES = 10
const FASES_PRONTAS = 10
const COLUNAS = 5

@onready var grid_fases: GridContainer = $CenterContainer/VBoxContainer/GridFases
@onready var botao_voltar: Button = $CenterContainer/VBoxContainer/BotaoVoltar
@onready var overlay_popup: ColorRect = $OverlayPopup
@onready var texto_popup: Label = $OverlayPopup/CenterContainer/PanelContainer/VBoxContainer/TextoPopup
@onready var botao_entendi: Button = $OverlayPopup/CenterContainer/PanelContainer/VBoxContainer/BotaoEntendi

var botoes_fases: Array[Button] = []
var indice_selecionado: int = 0
var menu_selecionado: bool = false
var fase_popup: int = 0


# ==========================================
# INICIALIZAÇÃO
# ==========================================

func _ready() -> void:
	get_tree().paused = false

	overlay_popup.hide()
	criar_botoes()
	configurar_vizinhos()

	get_tree().node_configuration_warning_changed.connect(
	atualizar_traducoes
	)

	atualizar_traducoes()
	selecionar_botao(0)


# ==========================================
# ATUALIZAÇÃO DAS TRADUÇÕES
# ==========================================

func atualizar_traducoes() -> void:
	for i in range(botoes_fases.size()):
		var numero = i + 1
		var botao = botoes_fases[i]

		botao.text = tr("FASE") + " " + str(numero)

		if numero <= FASES_PRONTAS:
			botao.text += " ✓"
		else:
			botao.text += " 🔒"

	botao_entendi.text = tr("ENTENDI")

	if overlay_popup.visible and fase_popup > 0:
		atualizar_texto_popup()


func atualizar_texto_popup() -> void:
	texto_popup.text = (
		tr("FASE") + " " + str(fase_popup) + " " +
		tr("FASE_DESENVOLVIMENTO") +
		"\n\n" +
		tr("AGUARDE_ATUALIZACOES")
	)


# ==========================================
# CONFIGURAR VIZINHOS
# ==========================================

func configurar_vizinhos() -> void:
	botao_voltar.focus_mode = Control.FOCUS_ALL

	for i in range(botoes_fases.size()):
		var botao = botoes_fases[i]
		var coluna = i % COLUNAS

		var esquerda = i
		var direita = i

		if coluna > 0:
			esquerda = i - 1

		if coluna < COLUNAS - 1:
			direita = i + 1

		botao.focus_neighbor_left = botao.get_path_to(
			botoes_fases[esquerda]
		)

		botao.focus_neighbor_right = botao.get_path_to(
			botoes_fases[direita]
		)

		if i >= COLUNAS:
			botao.focus_neighbor_top = botao.get_path_to(
				botoes_fases[i - COLUNAS]
			)

		if i + COLUNAS < botoes_fases.size():
			botao.focus_neighbor_bottom = botao.get_path_to(
				botoes_fases[i + COLUNAS]
			)
		else:
			botao.focus_neighbor_bottom = botao.get_path_to(
				botao_voltar
			)

	botao_voltar.focus_neighbor_left = botao_voltar.get_path()
	botao_voltar.focus_neighbor_right = botao_voltar.get_path()

	botao_voltar.focus_neighbor_top = botao_voltar.get_path_to(
		botoes_fases[5]
	)


# ==========================================
# CRIAÇÃO DOS BOTÕES
# ==========================================

func criar_botoes() -> void:
	for numero in range(1, TOTAL_FASES + 1):
		var botao = Button.new()

		botao.text = tr("FASE") + " " + str(numero)
		botao.custom_minimum_size = Vector2(110, 65)
		botao.focus_mode = Control.FOCUS_ALL

		# Texto já traduzido pelo script
		botao.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED

		var estilo = StyleBoxFlat.new()
		estilo.bg_color = Color("#101827")
		estilo.border_color = Color("#D99A62")
		estilo.set_border_width_all(2)
		estilo.set_corner_radius_all(6)

		botao.add_theme_stylebox_override("normal", estilo)

		var estilo_hover = estilo.duplicate()
		estilo_hover.bg_color = Color("#25394A")
		botao.add_theme_stylebox_override("hover", estilo_hover)

		# Destaque da seleção pelo teclado
		var estilo_foco = StyleBoxFlat.new()
		estilo_foco.bg_color = Color.TRANSPARENT
		estilo_foco.border_color = Color("#FFD700")
		estilo_foco.set_border_width_all(4)
		estilo_foco.set_corner_radius_all(8)

		botao.add_theme_stylebox_override("focus", estilo_foco)

		botao.add_theme_color_override(
			"font_color",
			Color("#FFE5BD")
		)

		botao.add_theme_color_override(
			"font_hover_color",
			Color("#FFE5BD")
		)

		if numero <= FASES_PRONTAS:
			botao.text += " ✓"
		else:
			botao.text += " 🔒"

		# Clique do mouse ou confirmação pelo teclado
		botao.pressed.connect(
			func(): selecionar_fase(numero)
		)

		grid_fases.add_child(botao)
		botoes_fases.append(botao)

		# Sincroniza a seleção quando usar o mouse
		var indice = numero - 1
		botao.focus_entered.connect(
			func(): indice_selecionado = indice
		)


# ==========================================
# NAVEGAÇÃO PELO TECLADO
# ==========================================

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	if overlay_popup.visible:
		if event.keycode == KEY_ESCAPE:
			fechar_popup()
			get_viewport().set_input_as_handled()
		return

	var tecla = event.physical_keycode
	var novo_indice = indice_selecionado

	if tecla == KEY_ESCAPE:
		_on_botao_voltar_pressed()
		get_viewport().set_input_as_handled()
		return

	# Quando BACK TO MENU está selecionado
	if menu_selecionado:
		if tecla == KEY_W or tecla == KEY_UP:
			menu_selecionado = false
			selecionar_botao(indice_selecionado)

		elif tecla == KEY_ENTER or tecla == KEY_KP_ENTER:
			_on_botao_voltar_pressed()

		else:
			return

		get_viewport().set_input_as_handled()
		return

	match tecla:
		KEY_A, KEY_LEFT:
			if indice_selecionado % COLUNAS > 0:
				novo_indice -= 1

		KEY_D, KEY_RIGHT:
			if indice_selecionado % COLUNAS < COLUNAS - 1:
				novo_indice += 1

		KEY_W, KEY_UP:
			if indice_selecionado >= COLUNAS:
				novo_indice -= COLUNAS

		KEY_S, KEY_DOWN:
			if indice_selecionado + COLUNAS < botoes_fases.size():
				novo_indice += COLUNAS
			else:
				selecionar_menu_voltar()
				get_viewport().set_input_as_handled()
				return

	if novo_indice != indice_selecionado:
		selecionar_botao(novo_indice)
		get_viewport().set_input_as_handled()


# ==========================================
# SELEÇÃO VISUAL
# ==========================================

func selecionar_botao(indice: int) -> void:
	if indice < 0 or indice >= botoes_fases.size():
		return

	menu_selecionado = false
	indice_selecionado = indice
	botoes_fases[indice_selecionado].grab_focus()


func selecionar_menu_voltar() -> void:
	menu_selecionado = true
	botao_voltar.grab_focus()


# ==========================================
# ABRIR FASE
# ==========================================

func selecionar_fase(numero: int) -> void:
	if numero > FASES_PRONTAS:
		fase_popup = numero
		atualizar_texto_popup()

		overlay_popup.show()
		botao_entendi.grab_focus()
		return

	Global.iniciar_fase(numero - 1)


# ==========================================
# FECHAR AVISO
# ==========================================

func fechar_popup() -> void:
	overlay_popup.hide()
	fase_popup = 0
	selecionar_botao(indice_selecionado)


func _on_botao_entendi_pressed() -> void:
	fechar_popup()


# ==========================================
# VOLTAR AO MENU PRINCIPAL
# ==========================================

func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file(MENU_PRINCIPAL)


extends Control

const MENU_PRINCIPAL = "res://menu/menu_principal/menu_principal.tscn"

@onready var botao_janela: Button = $CenterContainer/VBoxContainer/BotaoJanela
@onready var botao_tela_cheia: Button = $CenterContainer/VBoxContainer/BotaoTelaCheia
@onready var botao_voltar: Button = $CenterContainer/VBoxContainer/BotaoVoltar

var botoes: Array[Button] = []
var indice_selecionado: int = 0


func _ready() -> void:
	get_tree().paused = false

	botoes = [
		botao_janela,
		botao_tela_cheia,
		botao_voltar
	]

	for i in range(botoes.size()):
		var botao = botoes[i]
		botao.focus_mode = Control.FOCUS_ALL

		var indice = i
		botao.focus_entered.connect(
			func(): indice_selecionado = indice
		)

		var estilo_foco = StyleBoxFlat.new()
		estilo_foco.bg_color = Color.TRANSPARENT
		estilo_foco.border_color = Color("#FFD700")
		estilo_foco.set_border_width_all(4)
		estilo_foco.set_corner_radius_all(8)

		botao.add_theme_stylebox_override("focus", estilo_foco)

	botao_janela.pressed.connect(_on_botao_janela_pressed)
	botao_tela_cheia.pressed.connect(_on_botao_tela_cheia_pressed)
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)

	selecionar_botao(0)


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	match event.physical_keycode:
		KEY_W, KEY_UP:
			get_viewport().set_input_as_handled()
			mover_selecao(-1)

		KEY_S, KEY_DOWN:
			get_viewport().set_input_as_handled()
			mover_selecao(1)

		KEY_ENTER, KEY_KP_ENTER:
			get_viewport().set_input_as_handled()
			confirmar_selecao()

		KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			_on_botao_voltar_pressed()


func mover_selecao(direcao: int) -> void:
	var novo_indice = clampi(
		indice_selecionado + direcao,
		0,
		botoes.size() - 1
	)

	selecionar_botao(novo_indice)


func selecionar_botao(indice: int) -> void:
	if indice < 0 or indice >= botoes.size():
		return

	indice_selecionado = indice
	botoes[indice].grab_focus()


func confirmar_selecao() -> void:
	botoes[indice_selecionado].pressed.emit()


func _on_botao_janela_pressed() -> void:
	ConfiguracaoTela.ativar_modo_janela()


func _on_botao_tela_cheia_pressed() -> void:
	ConfiguracaoTela.ativar_tela_cheia()


func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file(MENU_PRINCIPAL)

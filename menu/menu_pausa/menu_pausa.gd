
extends CanvasLayer

# ==========================================
# REFERÊNCIAS
# ==========================================

@onready var fundo: ColorRect = $Fundo
@onready var center_container: CenterContainer = $Fundo/CenterContainer

@export var botao_continuar: Button
@export var botao_reiniciar: Button
@export var botao_menu: Button

var botoes: Array[Button] = []
var indice_selecionado: int = 0
var pausado: bool = false


# ==========================================
# INICIALIZAÇÃO
# ==========================================

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	fundo.hide()

	botoes = [
		botao_continuar,
		botao_reiniciar,
		botao_menu
	]

	for i in range(botoes.size()):
		var botao = botoes[i]

		botao.focus_mode = Control.FOCUS_ALL

		var indice = i
		botao.focus_entered.connect(
			func(): indice_selecionado = indice
		)

		# Destaque amarelo da seleção
		var estilo_foco = StyleBoxFlat.new()
		estilo_foco.bg_color = Color.TRANSPARENT
		estilo_foco.border_color = Color("#FFD700")
		estilo_foco.set_border_width_all(4)
		estilo_foco.set_corner_radius_all(8)

		botao.add_theme_stylebox_override(
			"focus",
			estilo_foco
		)


# ==========================================
# CONTROLE DO TECLADO
# ==========================================

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	# ESC abre ou fecha o menu de pausa
	if event.is_action_pressed("pausar"):
		if pausado:
			continuar_jogo()
		else:
			pausar_jogo()

		get_viewport().set_input_as_handled()
		return

	# Não navega se o menu estiver fechado
	if not pausado:
		return

	match event.physical_keycode:
		KEY_W, KEY_UP:
			mover_selecao(-1)
			get_viewport().set_input_as_handled()

		KEY_S, KEY_DOWN:
			mover_selecao(1)
			get_viewport().set_input_as_handled()
		
		KEY_ENTER, KEY_KP_ENTER:
			get_viewport().set_input_as_handled()
			confirmar_selecao()
			return
# ==========================================
# PAUSAR JOGO
# ==========================================

func pausar_jogo() -> void:
	pausado = true
	fundo.show()
	get_tree().paused = true

	# Começa selecionando CONTINUE
	selecionar_botao(0)


# ==========================================
# CONTINUAR JOGO
# ==========================================

func continuar_jogo() -> void:
	pausado = false
	get_tree().paused = false
	fundo.hide()

	# Remove o foco ao fechar
	if indice_selecionado >= 0:
		botoes[indice_selecionado].release_focus()


# ==========================================
# MOVIMENTAR SELEÇÃO
# ==========================================

func mover_selecao(direcao: int) -> void:
	var novo_indice = indice_selecionado + direcao

	novo_indice = clampi(
		novo_indice,
		0,
		botoes.size() - 1
	)

	selecionar_botao(novo_indice)


# ==========================================
# SELECIONAR BOTÃO
# ==========================================

func selecionar_botao(indice: int) -> void:
	if indice < 0 or indice >= botoes.size():
		return

	indice_selecionado = indice
	botoes[indice_selecionado].grab_focus()


# ==========================================
# CONFIRMAR SELEÇÃO
# ==========================================

func confirmar_selecao() -> void:
	match indice_selecionado:
		0:
			_on_botao_continuar_pressed()

		1:
			_on_botao_reiniciar_pressed()

		2:
			_on_botao_menu_pressed()


# ==========================================
# BOTÃO CONTINUAR
# ==========================================

func _on_botao_continuar_pressed() -> void:
	continuar_jogo()


# ==========================================
# BOTÃO REINICIAR
# ==========================================

func _on_botao_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


# ==========================================
# BOTÃO MENU PRINCIPAL
# ==========================================

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(
		"res://menu/menu_principal/menu_principal.tscn"
	)

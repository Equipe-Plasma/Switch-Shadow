
extends Control

const SELECAO_FASES = "res://menu/selecao_fases/selecao_fases.tscn"

# ==========================================
# REFERÊNCIAS DOS BOTÕES
# ==========================================

@export var botao_jogar: Button
@export var botao_selecionar: Button
@export var botao_options: Button
@export var botao_sair: Button

var botoes: Array[Button] = []
var indice_selecionado: int = 0


# ==========================================
# INICIALIZAÇÃO
# ==========================================

func _ready() -> void:
	get_tree().paused = false

	botoes = [
		botao_jogar,
		botao_selecionar,
		botao_options,
		botao_sair
	]

	for i in range(botoes.size()):
		var botao = botoes[i]

		botao.focus_mode = Control.FOCUS_ALL

		var indice = i
		botao.focus_entered.connect(
			func(): indice_selecionado = indice
		)

		var estilo_normal = StyleBoxFlat.new()
		estilo_normal.bg_color = Color.TRANSPARENT 
		estilo_normal.border_color = Color(0.734, 0.436, 1.0, 1.0) 
		estilo_normal.set_border_width_all(4)
		estilo_normal.set_corner_radius_all(8)
		
		botao.add_theme_stylebox_override("normal", estilo_normal)

		var estilo_foco = StyleBoxFlat.new()
		estilo_foco.bg_color = Color.TRANSPARENT
		estilo_foco.border_color = Color("4f0072ff")
		estilo_foco.set_border_width_all(4)
		estilo_foco.set_corner_radius_all(8)

		botao.add_theme_stylebox_override(
			"focus",
			estilo_foco
		)

	selecionar_botao(0)


# ==========================================
# NAVEGAÇÃO PELO TECLADO
# ==========================================

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
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
	botoes[indice_selecionado].pressed.emit()


# ==========================================
# BOTÃO PLAY
# ==========================================

func _on_botao_jogar_pressed() -> void:
	Global.iniciar_fase(0)


# ==========================================
# BOTÃO SELECT LEVEL
# ==========================================

func _on_botao_selecionar_pressed() -> void:
	get_tree().change_scene_to_file(SELECAO_FASES)


# ==========================================
# BOTÃO EXIT
# ==========================================

func _on_botao_sair_pressed() -> void:
	get_tree().quit()


func _on_botao_opcoes_pressed() -> void:
	print("Options selecionado!")
	get_tree().change_scene_to_file(
		"res://menu/opcoes/menu_opcoes.tscn"
	)


extends Control

const MENU_PRINCIPAL = "res://menu/menu_principal/menu_principal.tscn"

# Caminho da próxima fase configurável pelo Inspetor
@export_file("*.tscn") var proxima_fase: String

# ==========================================
# REFERÊNCIAS DOS BOTÕES
# ==========================================

@export var botao_proxima_fase: Button
@export var botao_menu: Button
@onready var audio_vitoria: AudioStreamPlayer = $audio_vitoria

var botoes: Array[Button] = []
var indice_selecionado: int = 0


# ==========================================
# INICIALIZAÇÃO
# ==========================================

func _ready() -> void:
	get_tree().paused = false

	botoes = [
		botao_proxima_fase,
		botao_menu
	]

	for i in range(botoes.size()):
		var botao = botoes[i]

		if botao == null:
			push_error("Um botão da Tela de Vitória não foi configurado no Inspetor!")
			return

		botao.focus_mode = Control.FOCUS_ALL

		var indice = i
		botao.focus_entered.connect(
			func(): indice_selecionado = indice
		)

		# Destaque amarelo do botão selecionado
		var estilo_foco = StyleBoxFlat.new()
		estilo_foco.bg_color = Color.TRANSPARENT
		estilo_foco.border_color = Color("#FFD700")
		estilo_foco.set_border_width_all(4)
		estilo_foco.set_corner_radius_all(8)

		botao.add_theme_stylebox_override("focus", estilo_foco)

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



# ==========================================
# MOVIMENTAR SELEÇÃO
# ==========================================

func mover_selecao(direcao: int) -> void:
	if botoes.is_empty():
		return

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

	if botoes[indice] == null:
		return

	indice_selecionado = indice
	botoes[indice_selecionado].grab_focus()


# ==========================================
# CONFIRMAR SELEÇÃO
# ==========================================

func confirmar_selecao() -> void:
	if indice_selecionado < 0 or indice_selecionado >= botoes.size():
		return

	if botoes[indice_selecionado] == null:
		return

	# Executa a mesma ação do clique do mouse
	botoes[indice_selecionado].pressed.emit()


# ==========================================
# PRÓXIMA FASE
# ==========================================

func _on_botao_proxima_fase_pressed() -> void:
	Global.proxima_fase()

# ==========================================
# VOLTAR AO MENU PRINCIPAL
# ==========================================

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU_PRINCIPAL)

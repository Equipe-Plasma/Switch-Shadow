
extends Control

# ==========================================
# REFERÊNCIAS DOS BOTÕES
# ==========================================

@export var botao_tentar_novamente: Button
@export var botao_menu: Button
@onready var morte: AudioStreamPlayer = $morte

var botoes: Array[Button] = []
var indice_selecionado: int = 0

const MENU_PRINCIPAL = "res://menu/menu_principal/menu_principal.tscn"


# ==========================================
# INICIALIZAÇÃO
# ==========================================

func _ready() -> void:
	get_tree().paused = false
	morte.play()

	botoes = [
		botao_tentar_novamente,
		botao_menu
	]

	for i in range(botoes.size()):
		var botao = botoes[i]

		botao.focus_mode = Control.FOCUS_ALL

		var indice = i
		botao.focus_entered.connect(
			func(): indice_selecionado = indice
		)

		# Destaque visual amarelo
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
	match indice_selecionado:
		0:
			_on_botao_tentar_novamente_pressed()

		1:
			_on_botao_menu_pressed()


# ==========================================
# TENTAR NOVAMENTE
# ==========================================

func _on_botao_tentar_novamente_pressed() -> void:
	if Global.ultima_fase != "":
		get_tree().change_scene_to_file(Global.ultima_fase)
	else:
		print("Erro: Nenhuma fase anterior registrada.")


# ==========================================
# VOLTAR AO MENU PRINCIPAL
# ==========================================

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU_PRINCIPAL)

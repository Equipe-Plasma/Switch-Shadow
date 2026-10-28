
extends Control

const FASE_1 = "res://fase/fase 1/fase_1.tscn"
const FASE_2 = "res://fase/fase 2/fase_2.tscn"

@onready var selecao_fases = $CenterContainer/VBoxContainer/SelecaoFases

func _ready() -> void:
	selecao_fases.hide()

func _on_botao_jogar_pressed() -> void:
	Global.iniciar_fase(0)

func _on_botao_selecionar_pressed() -> void:
	selecao_fases.visible = not selecao_fases.visible

func _on_botao_fase_1_pressed() -> void:
	abrir_fase(FASE_1)

func _on_botao_fase_2_pressed() -> void:
	abrir_fase(FASE_2)

func _on_botao_sair_pressed() -> void:
	get_tree().quit()

func abrir_fase(caminho: String) -> void:
	Global.ultima_fase = caminho
	var erro = get_tree().change_scene_to_file(caminho)

	if erro != OK:
		push_error("Erro ao carregar a fase: " + caminho)

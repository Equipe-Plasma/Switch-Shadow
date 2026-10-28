
extends Control

const SELECAO_FASES = "res://menu/selecao_fases.tscn"

func _ready() -> void:
	get_tree().paused = false

func _on_botao_jogar_pressed() -> void:
	Global.iniciar_fase(0)

func _on_botao_selecionar_pressed() -> void:
	get_tree().change_scene_to_file(SELECAO_FASES)

func _on_botao_sair_pressed() -> void:
	get_tree().quit()

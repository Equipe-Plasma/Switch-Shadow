
extends Node

var modo_tela_cheia: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	modo_tela_cheia = (
		DisplayServer.window_get_mode()
		== DisplayServer.WINDOW_MODE_FULLSCREEN
	)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_F11:
				alternar_modo_tela()
				get_viewport().set_input_as_handled()


func alternar_modo_tela() -> void:
	if modo_tela_cheia:
		ativar_modo_janela()
	else:
		ativar_tela_cheia()


func ativar_tela_cheia() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN
	)

	modo_tela_cheia = true


func ativar_modo_janela() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED
	)

	modo_tela_cheia = false

	# Define um tamanho grande para a janela
	DisplayServer.window_set_size(Vector2i(1280, 720))

	# Centraliza a janela no monitor
	var tela = DisplayServer.window_get_current_screen()
	var posicao_tela = DisplayServer.screen_get_position(tela)
	var tamanho_tela = DisplayServer.screen_get_size(tela)
	var tamanho_janela = DisplayServer.window_get_size()

	DisplayServer.window_set_position(
		posicao_tela + (tamanho_tela - tamanho_janela) / 2
	)

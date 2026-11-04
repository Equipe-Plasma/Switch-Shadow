
extends Node

const CAMINHO_CONFIG = "user://configuracoes.cfg"

var modo_tela_cheia: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Carrega a preferência salva ao iniciar o jogo.
	carregar_configuracao_tela()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_F11:
				alternar_modo_tela()
				get_viewport().set_input_as_handled()


# Alterna entre tela cheia e modo janela.
func alternar_modo_tela() -> void:
	if modo_tela_cheia:
		ativar_modo_janela()
	else:
		ativar_tela_cheia()


# Ativa o modo tela cheia.
func ativar_tela_cheia() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN
	)

	modo_tela_cheia = true

	# Salva a preferência do jogador.
	salvar_configuracao_tela()


# Ativa o modo janela.
func ativar_modo_janela() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED
	)

	modo_tela_cheia = false

	# Define o tamanho da janela.
	DisplayServer.window_set_size(Vector2i(1280, 720))

	# Centraliza a janela no monitor.
	var tela = DisplayServer.window_get_current_screen()
	var posicao_tela = DisplayServer.screen_get_position(tela)
	var tamanho_tela = DisplayServer.screen_get_size(tela)
	var tamanho_janela = DisplayServer.window_get_size()

	DisplayServer.window_set_position(
		posicao_tela + (tamanho_tela - tamanho_janela) / 2
	)

	# Salva a preferência do jogador.
	salvar_configuracao_tela()


# Salva a configuração em um arquivo.
func salvar_configuracao_tela() -> void:
	var config = ConfigFile.new()

	# Carrega configurações existentes, caso existam.
	config.load(CAMINHO_CONFIG)

	config.set_value(
		"video",
		"tela_cheia",
		modo_tela_cheia
	)

	var erro = config.save(CAMINHO_CONFIG)

	if erro != OK:
		push_error(
			"Erro ao salvar configuração de tela: " + str(erro)
		)


# Carrega a configuração salva ao iniciar.
func carregar_configuracao_tela() -> void:
	var config = ConfigFile.new()

	var erro = config.load(CAMINHO_CONFIG)

	if erro != OK:
		# Primeira execução: inicia em modo janela.
		ativar_modo_janela()
		return

	var tela_cheia: bool = config.get_value(
		"video",
		"tela_cheia",
		false
	)

	if tela_cheia:
		ativar_tela_cheia()
	else:
		ativar_modo_janela()

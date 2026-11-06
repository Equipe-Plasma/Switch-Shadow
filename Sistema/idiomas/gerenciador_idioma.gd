
extends Node

const CAMINHO_CONFIG: String = "user://idioma.cfg"
const IDIOMA_PADRAO: String = "en"


func _ready() -> void:
	carregar_idioma()


func alterar_idioma(codigo: String) -> void:
	TranslationServer.set_locale(codigo)
	salvar_idioma(codigo)


func salvar_idioma(codigo: String) -> void:
	var config = ConfigFile.new()

	config.set_value("idioma", "atual", codigo)

	var erro = config.save(CAMINHO_CONFIG)

	if erro != OK:
		push_error("Erro ao salvar idioma: " + str(erro))


func carregar_idioma() -> void:
	var config = ConfigFile.new()

	var erro = config.load(CAMINHO_CONFIG)

	if erro == OK:
		var idioma: String = config.get_value(
			"idioma",
			"atual",
			IDIOMA_PADRAO
		)

		if idioma != "en" and idioma != "pt_BR":
			idioma = IDIOMA_PADRAO

		TranslationServer.set_locale(idioma)
	else:
		# Primeira execução: inglês.
		TranslationServer.set_locale(IDIOMA_PADRAO)

	print(
		"Idioma carregado: ",
		TranslationServer.get_locale()
	)

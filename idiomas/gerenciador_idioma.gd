extends Node

const CAMINHO_CONFIG = "user://idioma.cfg"

func _ready() -> void:
	carregar_idioma()


func alterar_idioma(codigo: String) -> void:
	TranslationServer.set_locale(codigo)
	salvar_idioma(codigo)


func salvar_idioma(codigo: String) -> void:
	var config = ConfigFile.new()
	config.set_value("idioma", "atual", codigo)
	config.save(CAMINHO_CONFIG)


func carregar_idioma() -> void:
	var config = ConfigFile.new()

	if config.load(CAMINHO_CONFIG) == OK:
		var idioma = config.get_value(
			"idioma",
			"atual",
            "pt_BR"
		)
		TranslationServer.set_locale(idioma)
	else:
		TranslationServer.set_locale("pt_BR")

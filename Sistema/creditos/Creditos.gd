
extends ScrollContainer
# Velocidade em pixels por segundo.
# Quanto menor, mais lento.
@export_range(1.0, 100.0, 1.0)
var velocidade_creditos: float = 8.0

@export var margem_extra: float = 0.0

# Caminho do menu principal.
const CAMINHO_MENU: String = "res://menu/menu_principal/menu_principal.tscn"
@onready var margin: MarginContainer = $Margin
@onready var text_node: RichTextLabel = $Margin/Label
var creditos_iniciados: bool = false
var posicao_rolagem: float = 0.0
var finalizando: bool = false

func _ready() -> void:
	creditos_iniciados = false

	# Configura os textos no idioma atual.
	_atualizar_traducoes()

	# Aguarda o Godot atualizar os elementos.
	await get_tree().process_frame
	await get_tree().process_frame

	var altura_tela: int = int(size.y)
	var margem_total: int = altura_tela + int(margem_extra)

	margin.add_theme_constant_override(
		"margin_top",
		margem_total
	)

	margin.add_theme_constant_override(
		"margin_bottom",
		margem_total
	)

	await get_tree().process_frame
	await get_tree().process_frame

	scroll_vertical = 0
	posicao_rolagem = 0.0

	creditos_iniciados = true
	
func _process(delta: float) -> void:
	if not creditos_iniciados:
		return

	posicao_rolagem += velocidade_creditos * delta

	var barra: VScrollBar = get_v_scroll_bar()

	var limite: float = maxf(
		0.0,
		barra.max_value - barra.page
	)

	scroll_vertical = int(
		minf(posicao_rolagem, limite)
	)

	if limite > 0.0 and posicao_rolagem >= limite:
		creditos_iniciados = false
		_acabou()
		
func _atualizar_traducoes() -> void:
	text_node.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	text_node.bbcode_enabled = true
	text_node.fit_content = true

	print("Idioma atual: ", TranslationServer.get_locale())

	var conteudo: String = """[center]
[b][u]%s[/u][/b]

[b]%s[/b]
Giovani
Gustavo
Rubens
Ghabriel

[b]%s[/b]
Ghabriel

[b]%s[/b]
%s

[b]%s[/b]
[/center]""" % [
		tr("CREDITOS_TITULO"),
		tr("CREDITOS_PROGRAMACAO"),
		tr("CREDITOS_ARTES"),
		tr("CREDITOS_MUSICAS_SONS"),
		tr("CREDITOS_A_DEFINIR"),
		tr("CREDITOS_AGRADECIMENTO")
	]
	text_node.text = conteudo
	
func _acabou() -> void:
	if finalizando:
		return

	finalizando = true

	print("Créditos finalizados!")

	var erro: Error = get_tree().change_scene_to_file(
		CAMINHO_MENU
	)

	if erro != OK:
		push_error(
			"Erro ao retornar ao menu: " + str(erro)
		)

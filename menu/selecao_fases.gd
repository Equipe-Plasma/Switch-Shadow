
extends Control

const MENU_PRINCIPAL = "res://menu/menu_principal.tscn"

const TOTAL_FASES = 10
const FASES_PRONTAS = 3

@onready var grid_fases: GridContainer = $CenterContainer/VBoxContainer/GridFases

@onready var overlay_popup: ColorRect = $OverlayPopup

@onready var texto_popup: Label = $OverlayPopup/CenterContainer/PanelContainer/VBoxContainer/TextoPopup


func _ready() -> void:
	get_tree().paused = false
	criar_botoes()
	overlay_popup.hide()

func criar_botoes() -> void:
	for numero in range(1, TOTAL_FASES + 1):
		var botao = Button.new()

		botao.text = "Fase " + str(numero)
		botao.custom_minimum_size = Vector2(110, 65)
		
		var estilo = StyleBoxFlat.new()
		estilo.bg_color = Color("#101827")
		estilo.border_color = Color("#D99A62")
		estilo.set_border_width_all(2)
		estilo.set_corner_radius_all(6)

		botao.add_theme_stylebox_override("normal", estilo)

		var estilo_hover = estilo.duplicate()
		estilo_hover.bg_color = Color("#25394A")

		botao.add_theme_stylebox_override("hover", estilo_hover)

		botao.add_theme_color_override(
			"font_color",
			Color("#FFE5BD")
		)

		botao.add_theme_color_override(
			"font_hover_color",
			Color("#FFE5BD")
		)


		if numero <= FASES_PRONTAS:
			botao.text += " ✓"
		else:
			botao.text += " 🔒"

		botao.pressed.connect(
			func(): selecionar_fase(numero)
		)

		grid_fases.add_child(botao)



func selecionar_fase(numero: int) -> void:
	if numero > FASES_PRONTAS:
		texto_popup.text = (
			"Fase " + str(numero) +
			" it's still in development!\n\n" +
            "Wait for the next updates."
		)

		overlay_popup.show()
		return

	Global.iniciar_fase(numero - 1)

func _on_botao_voltar_pressed() -> void:
	get_tree().change_scene_to_file(MENU_PRINCIPAL)


func _on_botao_entendi_pressed() -> void:
	overlay_popup.hide()

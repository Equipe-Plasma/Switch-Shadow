
extends CanvasLayer

@onready var fundo: ColorRect = $Fundo
@onready var center_container: CenterContainer = $Fundo/CenterContainer

var pausado: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	fundo.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausar"):
		if pausado:
			continuar_jogo()
		else:
			pausar_jogo()

		get_viewport().set_input_as_handled()

func pausar_jogo() -> void:
	pausado = true
	fundo.show()
	get_tree().paused = true

func continuar_jogo() -> void:
	pausado = false
	get_tree().paused = false
	fundo.hide()

func _on_botao_continuar_pressed() -> void:
	continuar_jogo()

func _on_botao_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(
        "res://menu/menu_principal.tscn"
	)

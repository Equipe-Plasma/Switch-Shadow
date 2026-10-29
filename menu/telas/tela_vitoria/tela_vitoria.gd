extends Control

# Caminho da próxima fase configurável pelo Inspetor
@export_file("*.tscn") var proxima_fase: String

func _on_botao_proxima_fase_pressed() -> void:
	Global.proxima_fase()


func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://menu/menu_principal/menu_principal.tscn"
		)

extends Control

# Caminho da próxima fase configurável pelo Inspetor
@export_file("*.tscn") var proxima_fase: String

func _on_botao_proxima_fase_pressed() -> void:
	if proxima_fase != "":
		get_tree().change_scene_to_file(proxima_fase)
	else:
		print("Próxima fase não configurada!")

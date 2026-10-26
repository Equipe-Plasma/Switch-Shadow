extends Control

func _on_botao_tentar_novamente_pressed() -> void:
	# Recarrega a fase atual
	get_tree().reload_current_scene()

extends Control

# Caminho da próxima fase configurável pelo Inspetor
@export_file("*.tscn") var proxima_fase: String

func _on_botao_proxima_fase_pressed() -> void:
	Global.proxima_fase()

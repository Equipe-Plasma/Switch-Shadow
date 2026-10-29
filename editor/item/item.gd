extends Area2D

# Esta função é chamada automaticamente pelo Godot quando algo entra na área do item
func _on_body_entered(body: Node2D) -> void:
	# Verifica se quem encostou é o Player
	if body.name == "Player":
		# Emite um aviso para quem estiver ouvindo que este item foi coletado
		# Depois remove o item da fase
		queue_free()

extends Area2D

@onready var item_coletado: AudioStreamPlayer2D = $Item_coletado
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# 1. Desativa a colisão e esconde o visual na hora
		collision.set_deferred("disabled", true)
		if sprite:
			sprite.visible = false
		
		# 2. Toca o som (mas precisamos reparentar ele para a raiz da cena para 
		# não ser destruído junto com o item quando dermos queue_free)
		if item_coletado.stream:
			# Tira o player de áudio de dentro do item e joga na cena principal (root)
			var audio_clone = item_coletado.duplicate()
			get_tree().root.add_child(audio_clone)
			audio_clone.global_position = global_position # Se for AudioStreamPlayer2D
			audio_clone.play()
			# Opcional: faz o clone se destruir sozinho quando o áudio acabar
			audio_clone.finished.connect(audio_clone.queue_free)

		# 3. Remove o item imediatamente para o contador/portal funcionar na hora
		queue_free()

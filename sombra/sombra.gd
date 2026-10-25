extends CharacterBody2D

@export var velocidade: float = 200.0

func _physics_process(_delta: float) -> void:
	# Exemplo: A sombra faz o movimento idêntico ao player
	# (Se quiser que ela vá para o lado oposto, troque mover_esquerda por mover_direita e vice-versa)
	var direcao := Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	
	velocity = direcao * velocidade
	move_and_slide()

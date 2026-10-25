extends CharacterBody2D

@export var velocidade: float = 200.0

func _physics_process(_delta: float) -> void:
	# Pega os botões que configuramos no Input Map
	var direcao := Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	
	# Aplica a velocidade de movimento
	velocity = direcao * velocidade
	move_and_slide()

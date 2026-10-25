extends CharacterBody2D

@export var velocidade: float = 200.0
@onready var sprite: Sprite2D = $Sprite2D


@export var textura_frente: Texture2D   # Para quando anda para baixo
@export var textura_costas: Texture2D   # Para quando anda para cima
@export var textura_dos_lados_direta: Texture2D  # Para quando anda para os lados

func _physics_process(_delta: float) -> void:
	# Exemplo: A sombra faz o movimento idêntico ao player
	# (Se quiser que ela vá para o lado oposto, troque mover_esquerda por mover_direita e vice-versa)
	var direcao := Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	
	velocity = direcao * velocidade
	move_and_slide()

# Só muda o visual se o personagem estiver realmente se movendo
	if direcao != Vector2.ZERO:
		# Compara se o movimento vertical é maior que o horizontal para ter prioridade
		if abs(direcao.y) > abs(direcao.x):
			if direcao.y > 0:
				# Movendo para baixo
				if textura_frente:
					sprite.texture = textura_frente
				sprite.flip_h = false
			else:
				# Movendo para cima
				if textura_costas:
					sprite.texture = textura_costas
				sprite.flip_h = false
		else:
			# Movendo para os lados (Esquerda ou Direita)
			if textura_dos_lados_direta:
				sprite.texture = textura_dos_lados_direta
				
			if direcao.x > 0:
				sprite.flip_h = false  # Direita (normal)
			elif direcao.x < 0:
				sprite.flip_h = true   # Esquerda (espelhado)

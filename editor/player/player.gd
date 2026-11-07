extends CharacterBody2D

@export var velocidade: float = 200.0
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")

@export var textura_frente: Texture2D
@export var textura_costas: Texture2D
@export var textura_dos_lados_direta: Texture2D

func _physics_process(_delta: float) -> void:
	var direcao := Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	velocity = direcao * velocidade
	move_and_slide()

	# Atualiza o sprite somente enquanto o personagem estiver se movendo.
	if direcao == Vector2.ZERO or not is_instance_valid(sprite):
		return

	if abs(direcao.y) > abs(direcao.x):
		if direcao.y > 0:
			if textura_frente:
				sprite.texture = textura_frente
		else:
			if textura_costas:
				sprite.texture = textura_costas
		sprite.flip_h = false
	else:
		if textura_dos_lados_direta:
			sprite.texture = textura_dos_lados_direta
		# A sombra reversa mantém a orientação invertida que já existia no projeto.
		if direcao.x > 0:
			sprite.flip_h = false
		elif direcao.x < 0:
			sprite.flip_h = true

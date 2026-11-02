@tool
extends StaticBody2D

@export var tamanho: Vector2 = Vector2(128, 128):
	set(valor):
		tamanho = Vector2(
			maxf(valor.x, 16.0),
			maxf(valor.y, 16.0)
		)
		atualizar_parede()

@onready var textura: TextureRect = $Textura
@onready var colisao: CollisionShape2D = $CollisionShape2D
# Pega a Area2D filha que criamos para detectar a troca
@onready var area_deteccao: Area2D = $AreaDeteccao 
@onready var colisao_area: CollisionShape2D = $AreaDeteccao/CollisionShape2D

func _ready() -> void:
	if not is_in_group("paredes_anti_troca"):
		add_to_group("paredes_anti_troca")

	# Configura o shape físico principal
	if colisao.shape == null:
		colisao.shape = RectangleShape2D.new()
	else:
		colisao.shape = colisao.shape.duplicate()

	# Configura o shape da Area2D interna para usar o overlaps_body depois
	if colisao_area.shape == null:
		colisao_area.shape = RectangleShape2D.new()
	else:
		colisao_area.shape = colisao_area.shape.duplicate()

	atualizar_parede()

func atualizar_parede() -> void:
	if not is_node_ready():
		return

	# Ajusta a textura
	if textura:
		textura.position = -tamanho / 2.0
		textura.size = tamanho
		textura.stretch_mode = TextureRect.STRETCH_TILE

	# Ajusta a colisão física
	if colisao and colisao.shape is RectangleShape2D:
		colisao.shape.size = tamanho
		colisao.position = Vector2.ZERO
		# Deixe .disabled = true SE você quer que eles PASSEM POR CIMA dela andando.
		# Deixe .disabled = false SE você quer que ela seja uma parede sólida E proíba a troca.
		colisao.disabled = true 

	# Ajusta a colisão da área de detecção de troca
	if colisao_area and colisao_area.shape is RectangleShape2D:
		colisao_area.shape.size = tamanho
		colisao_area.position = Vector2.ZERO


extends Area2D

signal estado_alterado(pressionado: bool)

var pressionado: bool = false
var corpos_no_botao: Array[Node2D] = []


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	print("Entrou na área: ", body.name)

	if body.name == "Player" or body.name == "Sombra":
		if not corpos_no_botao.has(body):
			corpos_no_botao.append(body)

		atualizar_estado()


func _on_body_exited(body: Node2D) -> void:
	print("Saiu da área: ", body.name)

	if body.name == "Player" or body.name == "Sombra":
		corpos_no_botao.erase(body)
		atualizar_estado()


func atualizar_estado() -> void:
	var novo_estado: bool = corpos_no_botao.size() > 0

	if novo_estado != pressionado:
		pressionado = novo_estado

		print("Emitindo sinal: ", pressionado)
		estado_alterado.emit(pressionado)

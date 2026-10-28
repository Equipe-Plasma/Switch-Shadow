extends Node

# Variável para guardar o caminho da última fase jogada
var ultima_fase: String = ""

var fases: Array[String] = [
	"res://fase/fase 1/fase_1.tscn",
    "res://fase/fase 2/fase_2.tscn"
]

var fase_atual: int = 0

func iniciar_fase(indice: int) -> void:
	if indice < 0 or indice >= fases.size():
		push_error("Fase inválida!")
		return

	fase_atual = indice
	ultima_fase = fases[indice]
	get_tree().change_scene_to_file(ultima_fase)

func proxima_fase() -> void:
	if fase_atual + 1 < fases.size():
		iniciar_fase(fase_atual + 1)
	else:
		print("Todas as fases foram concluídas!")

func registrar_fase(caminho: String) -> void:
	var indice = fases.find(caminho)

	if indice != -1:
		fase_atual = indice
		ultima_fase = caminho

extends Control

func _on_botao_tentar_novamente_pressed() -> void:
	# Verifica se temos uma fase salva para recarregar
	if Global.ultima_fase != "":
		get_tree().change_scene_to_file(Global.ultima_fase)
	else:
		# Plano B caso algo dê errado: recarrega a cena atual ou vai pro menu principal
		print("Erro: Nenhuma fase anterior registrada.")

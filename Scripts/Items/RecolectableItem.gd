extends Area2D

@export var idItem: int = 0
@export var value: int = 0

func _ready():
	match idItem:
		1:
			$Sprite2D.texture = preload("res://assets/Items/Cereza.png")
		2:
			$Sprite2D.texture = preload("res://assets/Items/Diamante_Rojo.png")

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Goofy":
		return

	var dataNode = get_node("/root/Main_Stage/DataController")

	match idItem:
		1:
			dataNode.add_coins(value)
			queue_free()
		2:
			dataNode.add_coins(value)
			queue_free()

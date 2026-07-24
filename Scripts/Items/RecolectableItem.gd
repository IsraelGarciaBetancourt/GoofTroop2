extends Area2D
class_name RecolectableItem

@export var idItem: int = 0
@export var value: int = 0

func _ready() -> void:
	match idItem:
		1:
			$Sprite2D.texture = preload("res://assets/Items/Cereza.png")
		2:
			$Sprite2D.texture = preload("res://assets/Items/Diamante_Rojo.png")

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return

	var dataNode := get_tree().get_first_node_in_group("DataController")
	if dataNode == null:
		push_error("No encontré DataController (grupo). ¿No está en Main_Stage?")
		return

	dataNode.add_coins(value)
	queue_free()

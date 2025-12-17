extends Area2D

@export var idItem: int = 0
@export var value: int = 0

func _ready():
	match idItem:
		1:
			$Sprite2D.texture = preload("res://assets/Items/Cereza.png")
			
func _on_body_entered(body:Node2D):
	var dataNode = get_node("/root/Main_Stage/DataController")
	if(body.name == "Goofy"):
		match idItem:
			1: 
				dataNode.coins = value
				queue_free()

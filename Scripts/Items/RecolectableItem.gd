extends Area2D

@export var idItem: int = 0

func _ready():
    match idItem:
        1:
            $Sprite2D.texture = preload("res://assets/Items/Cereza.png")
            
func _on_body_entered(body:Node2D):
    if(body.name == "Goofy"):
        queue_free()

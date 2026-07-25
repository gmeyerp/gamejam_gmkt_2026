extends Node3D
class_name DirtPile

var counter = 0
@export var object_to_pile : PackedScene
@export var object_size : float = 0.25

func pile():
	print(name + " pile")
	var instance = object_to_pile.instantiate()
	add_child(instance)
	instance.position += Vector3.UP * object_size * counter
	counter += 1

func clean():
	print(name + " clean")
	var piles = get_children()
	for i in range(piles.size(),-1):
		piles[i].queue_free()
	counter = 0

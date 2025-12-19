extends Node

signal dataChange

var vida: int = 1
var _coins: int = 0
var _max_coins: int = 7

var coins: int:
	get:
		return _coins
	set(value):
		_coins = clamp(value, 0, _max_coins)
		dataChange.emit()

var max_coins: int:
	get:
		return _max_coins
	set(value):
		_max_coins = max(value, 0)
		_coins = clamp(_coins, 0, _max_coins)
		dataChange.emit()

func check_max_coins() -> void:
	if coins >= max_coins:
		coins = 0
		vida += 1
		dataChange.emit()

func add_coins(amount: int) -> void:
	coins = _coins + amount
	check_max_coins()

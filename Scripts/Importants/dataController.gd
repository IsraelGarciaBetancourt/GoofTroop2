extends Node

signal dataChange 

var coins: int = 0:
	get:
		return coins
	set(value):
		coins += clamp(value,1,max_coins)
		if(coins >= max_coins):
			coins = max_coins
		dataChange.emit()

var max_coins: int = 99: 
	get:
		return max_coins
	set(value):
		max_coins = max(value,max_coins)
		dataChange.emit();
				
	

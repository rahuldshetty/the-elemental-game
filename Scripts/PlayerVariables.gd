extends Node

var PLAYER_MAX_HEALTH:float = 100.0
var PLAYER_MAX_MANA:float = 100.0

var player_speed:float = 125.0
var player_health:float = PLAYER_MAX_HEALTH
var player_mana:float = PLAYER_MAX_MANA
var player_gold:int = 0

var level:int = 0
var xp:int = 0
const LEVEL_UP_XP = 1500

# Increase stats every offset levels 
const STAT_INCREASE_LEVEL_OFFSET:int = 5
const HP_STAT_INCREASE_DELTA:int = 15
const MANA_STAT_INCREASE_DELTA:int = 25

func get_max_health():
	return PLAYER_MAX_HEALTH + (PlayerVariables.level / PlayerVariables.STAT_INCREASE_LEVEL_OFFSET) * PlayerVariables.HP_STAT_INCREASE_DELTA

func get_max_mana():
	return PLAYER_MAX_MANA + (PlayerVariables.level / PlayerVariables.STAT_INCREASE_LEVEL_OFFSET) * PlayerVariables.MANA_STAT_INCREASE_DELTA

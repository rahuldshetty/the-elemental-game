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

extends Node

## Persists across scene reloads (autoload singleton), so the death count
## survives the reload_current_scene() calls that happen on every death.

var deaths := 0

func die() -> void:
	register_death()
	get_tree().call_deferred("reload_current_scene")
	

func register_death() -> void:
	deaths += 1

func reset() -> void:
	deaths = 0

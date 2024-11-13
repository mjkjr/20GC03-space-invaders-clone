extends Area2D

signal destroyed

enum Direction { LEFT, RIGHT }

const PROJECTILE = preload("res://enemies/projectile.tscn")

var movement_direction: Direction = Direction.RIGHT


func _ready() -> void:
	# randomize the shooting timer
	$Shoot.wait_time = randf_range(1, 120)
	$Shoot.start()


func set_type(which: int) -> void:
	$Sprite2D.frame = which


func move() -> void:
	if movement_direction == Direction.LEFT:
		if position.x == $Sprite2D.get_rect().size.x:
			position.y += $Sprite2D.get_rect().size.y
			movement_direction = Direction.RIGHT
		else:
			position.x -= $Sprite2D.get_rect().size.x
	else:
		if position.x == get_viewport_rect().size.x - ($Sprite2D.get_rect().size.x * 2):
			position.y += $Sprite2D.get_rect().size.y
			movement_direction = Direction.LEFT
		else:
			position.x += $Sprite2D.get_rect().size.x


func _on_move_timeout() -> void:
	move()


func _on_shoot_timeout() -> void:
	var projectile = PROJECTILE.instantiate()
	projectile.position.x = global_position.x + 33
	projectile.position.y = global_position.y + 21
	add_sibling(projectile)
	$Shoot.wait_time = randf_range(1, 120)
	$Shoot.start()


func _on_hit(body: Node2D) -> void:
	if body.get_groups().has("projectiles"):
		destroyed.emit()
		print("TODO: add explosion and sound effect!")
		body.queue_free()
		queue_free()
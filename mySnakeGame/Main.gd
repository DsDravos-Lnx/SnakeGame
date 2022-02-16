extends Node2D

"create a constants and variables"
const SNAKE = 0
const APPLE = 1
var apple_pos 
var snake_body = [Vector2(5,9), Vector2(4,9), Vector2(3,9)]
var snake_direction = Vector2(1,0)
var add_apple = false

"ready the scripts"
func _ready():
	apple_pos = place_apple()
	draw_apple()
	draw_snake()
	
"replace a apple"
func place_apple():
	randomize()
	var x = randi() % 19
	var y = randi() % 19
	return Vector2(x, y)
	
"drawning a apple on Grid"
func draw_apple(): 
	$Grid.set_cell(apple_pos.x, apple_pos.y, APPLE)
	
"drawning a snake on Grid"
func draw_snake():
	for index_tile in snake_body.size():
		var tile = snake_body[index_tile]
		if index_tile == 0:
			var head_direction = compare(snake_body[0], snake_body[1])
			if head_direction == 'right':
				$Grid.set_cell(tile.x, tile.y, SNAKE, false, false, true, Vector2(0,1))
			if head_direction == 'left':
				$Grid.set_cell(tile.x, tile.y, SNAKE, true, true, true, Vector2(0,1))
			if head_direction == 'top':
				$Grid.set_cell(tile.x, tile.y, SNAKE, false, true, false, Vector2(0,1))
			if head_direction == 'bottom':
				$Grid.set_cell(tile.x, tile.y, SNAKE, false, false, false, Vector2(0,1))
		elif index_tile == snake_body.size() - 1:
			var tail_direction = compare(snake_body[-1], snake_body[-2])
			if tail_direction == 'right':
				$Grid.set_cell(tile.x, tile.y, SNAKE, false, false, true, Vector2(1,2))
			if tail_direction == 'left':
				$Grid.set_cell(tile.x, tile.y, SNAKE, true, true, true, Vector2(1,2))
			if tail_direction == 'top':
				$Grid.set_cell(tile.x, tile.y, SNAKE, false, true, false, Vector2(1,2))
			if tail_direction == 'bottom':
				$Grid.set_cell(tile.x, tile.y, SNAKE, false, false, false, Vector2(1,2))
		else:
			var previous_tile = snake_body[index_tile + 1] - tile
			var next_tile = snake_body[index_tile - 1] - tile
			
			if previous_tile.x == next_tile.x:
				$Grid.set_cell(tile.x, tile.y, SNAKE, false,false,false, Vector2(2,2))
			elif previous_tile.y == next_tile.y:
				$Grid.set_cell(tile.x, tile.y, SNAKE, false,false,true, Vector2(2,2))
			else:
				if previous_tile.x == -1 and next_tile.y == -1 or next_tile.x == -1 and previous_tile.y == -1:
					$Grid.set_cell(tile.x, tile.y, SNAKE, true,true,false, Vector2(1,0))
				if previous_tile.x == -1 and next_tile.y == 1 or next_tile.x == -1 and previous_tile.y == 1:
					$Grid.set_cell(tile.x, tile.y, SNAKE, true,true,false, Vector2(1,1))
				if previous_tile.x == 1 and next_tile.y == -1 or next_tile.x == 1 and previous_tile.y == -1:
					$Grid.set_cell(tile.x, tile.y, SNAKE, true,false,true, Vector2(2,1))
				if previous_tile.x == 1 and next_tile.y == 1 or next_tile.x == 1 and previous_tile.y == 1:
					$Grid.set_cell(tile.x, tile.y, SNAKE, false,false,false, Vector2(1,0))
				
func compare(first_block:Vector2, second_block:Vector2):
	var block_comparation = first_block - second_block
	if block_comparation == Vector2(-1, 0):
		return 'left'
	if block_comparation == Vector2(1, 0):
		return 'right'
	if block_comparation == Vector2(0, 1):
		return 'bottom'
	if block_comparation == Vector2(-0, -1):
		return 'top'

"moving a snake"
func move_snake():
	if add_apple:
		delete_tiles(SNAKE)
		var snakeBody_copy = snake_body.slice(0, snake_body.size() - 1)
		var new_head = snakeBody_copy[0] + snake_direction
		snakeBody_copy.insert(0, new_head)
		snake_body = snakeBody_copy
		add_apple = false
	else:
		delete_tiles(SNAKE)
		var snakeBody_copy = snake_body.slice(0, snake_body.size() - 2)
		var new_head = snakeBody_copy[0] + snake_direction
		snakeBody_copy.insert(0, new_head)
		snake_body = snakeBody_copy
	
"delete snake tiles cant be used"
func delete_tiles(id:int):
	var cells = $Grid.get_used_cells_by_id(id)
	for cell in cells:
		$Grid.set_cell(cell.x, cell.y, -1)
	
"check snake eaten apple"
func snake_eat_apple():
	if apple_pos == snake_body[0]:
		apple_pos = place_apple()
		add_apple = true

"check its game is over"
func game_over():
	var head = snake_body[0]
	# if snake collides the screen bord
	if head.x > 18 or head.x < 0 or head.y > 18 or head.y < 0:
		restart()
	# if snake collides own tail
	for block in snake_body.slice(1,snake_body.size() - 1):
		if block == head:
			restart()
	
"restart the game"
func restart():
	snake_body = [Vector2(5,9), Vector2(4,9), Vector2(3,9)]
	snake_direction = Vector2(1,0)
	
"setup a direction for a snake"
func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		if not snake_direction == Vector2(0, 1):
			snake_direction = Vector2(0, -1)
	if Input.is_action_just_pressed("ui_right"):
		if not snake_direction == Vector2(-1,0):
			snake_direction = Vector2(1, 0)
	if Input.is_action_just_pressed("ui_left"):
		if not snake_direction == Vector2(1, 0):
			snake_direction = Vector2(-1, 0)
	if Input.is_action_just_pressed("ui_down"):
		if not snake_direction == Vector2(0, -1):
			snake_direction = Vector2(0, 1)
		
"actions on snake time"
func _on_SnakeTick_timeout():
	move_snake()
	draw_apple()
	draw_snake()
	snake_eat_apple()
	game_over()

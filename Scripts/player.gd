extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -800.0


var GameStart = false

var InitialPos: Vector2


func _ready():
	GameStart = false
	InitialPos = position
	pass

func _physics_process(delta):

	if(!GameStart): return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

	# ? Debug Outputs
	# print("Falling? ", isFalling)
	# print(velocity.y)
	# print(position.y)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_tree_exiting():
	print("PLAYER DIED!!!")
	pass # Replace with function body.


func _on_button_pressed():
	position = InitialPos
	GameStart = true
	velocity.y = JUMP_VELOCITY * 1.5
	pass # Replace with function body.

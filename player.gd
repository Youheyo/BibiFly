extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -800.0
var gameStart = false

signal falling
var isFalling = false

func _ready():
	velocity.y = JUMP_VELOCITY * 1.5

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

	if(velocity.y > 0):
		isFalling = true
	else:
		isFalling = false

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

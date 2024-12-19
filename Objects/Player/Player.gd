extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	IDLE_TRANSFORMATION,
	STANDUP_IDLE
}
var current_state = State.IDLE

const SPEED = 130.0
const TRANSFORMATION_DELAY = 5 * 60
var stopped_time = 0
@export var camera: Camera2D = null
var initial_position = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var collisionBox = $CollisionShape2D
var random_animation_time = 0.0

var last_rotation = 0.0

const ninetyDegree = (PI/2);

var externalForce = Vector2(0,0)

var cameraOffset = Vector2(0,0)

func _physics_process(delta):
	handle_movement(delta)
	#state_handler(delta)
	handle_size(delta)
	handle_interact(delta)

var sizeProgress = 0
var sizeDirection = 0
var ableToTalk = false
var talkTo = null;
@onready var originalSize = self.scale
@onready var targetSize = originalSize * 1.2

@export var jumpSizeSpeed = 2

func handle_interact(delta):
	if(!ableToTalk):
		return
	handle_interact_anim(delta);
	if(!Input.is_action_pressed("interact")):
		return
	if(talkTo == null):
		return;
	print("NPC Talked with Value : " + talkTo.getDialogue())
	
	
	
func handle_interact_anim(delta):
	# Implement ME!
	return;

func handle_size(delta):
	# Update sizeProgress based on sizeDirection and delta
	sizeProgress += sizeDirection * delta * jumpSizeSpeed

	# Clamp sizeProgress to be between 0 and 1 to prevent overshooting
	sizeProgress = clamp(sizeProgress, 0, 1)

	# Lerp between the original size and target size based on sizeProgress
	self.scale = originalSize.lerp(targetSize, sizeProgress)
	
	# If the sizeProgress reaches 1, change direction (optional)
	if sizeProgress == 1:
		sizeDirection = -1  # Reverse the direction to shrink
	elif sizeProgress == 0:
		sizeDirection = 0

func handle_movement(_delta):
	
	# Camera Smoothing
	if camera != null:
		camera.global_position = camera.global_position.lerp(self.global_position, 0.1)
	
	
	if velocity == Vector2.ZERO:
		stopped_time += 1
	else:
		stopped_time = 0
	var direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var direction_y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	var move_direction = Vector2(direction, direction_y)
	
	if Input.is_action_just_pressed("jump") && sizeDirection == 0:
		sizeDirection = 1

	if move_direction != Vector2.ZERO:
		current_state = State.RUN
		last_rotation = move_direction.angle()
	else:
		if current_state != State.IDLE_TRANSFORMATION and current_state != State.STANDUP_IDLE:
			current_state = State.IDLE
		elif current_state == State.IDLE_TRANSFORMATION:
			frameChanged()
		else:
			current_state = State.STANDUP_IDLE

	if move_direction != Vector2.ZERO:
		animated_sprite.rotation = last_rotation
		collisionBox.rotation = last_rotation + ninetyDegree
	else:
		animated_sprite.rotation = last_rotation
		collisionBox.rotation = last_rotation + ninetyDegree
	
	
	velocity = (move_direction.normalized() + externalForce) * SPEED
	move_and_slide()

func state_handler(delta):
	match current_state:
		State.IDLE:
			if stopped_time >= TRANSFORMATION_DELAY:
				stopped_time = 0
				current_state = State.IDLE_TRANSFORMATION
			else:
				animated_sprite.play("rat_idle1")
		State.RUN:
			animated_sprite.play("rat_run")
		State.IDLE_TRANSFORMATION:
			if animated_sprite.animation != "IdleTransformation":
				animated_sprite.play("IdleTransformation")
		State.STANDUP_IDLE:
			random_animation_time -= delta
			if animated_sprite.frame == animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation) - 1:
				if randi() % 50 == 1:
					animated_sprite.play("rat_idle3")
				else:
					animated_sprite.play("rat_idle2")
				random_animation_time = 1.0

func frameChanged():
	if animated_sprite.frame == animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation) - 1:
		animEnd(animated_sprite.animation)

func animEnd(animation_name):
	if animation_name == "IdleTransformation":
		current_state = State.STANDUP_IDLE

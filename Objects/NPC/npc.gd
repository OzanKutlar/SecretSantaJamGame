extends StaticBody2D

@export var start_quest = "Change me!"
@export var mid_quest = ["Change me in the middle!", "This is a second dialogue!"]
@export var end_quest = "Change me! But end this time."
@export var post_quest = "You've already finished my task. Get out!"
@export var npc_name = "Default"
@export var isTalkable = false

var questState = 0
var cycleIndex = 0
var mission_id = -1
@onready var animated_sprite = $AnimatedSprite2D

@export var missionToGive := {
	"Mission Name": "Default Mission",
	"Mission Item": 0, # Example: ID for the item required for the mission
	"Mission Goal": 1, # Example: The number of items needed
	"Mission Given By": "Default",
	"Mission Reward": 1,
	"Reward Amount": 100
}

func getDialogue():
	match questState:
		0:
			return start_quest
		1:
			var mid_dialogue = mid_quest[cycleIndex % mid_quest.size()]
			cycleIndex += 1
			return mid_dialogue
		2:
			return end_quest
		3:
			return post_quest
		_:
			return "Invalid quest state."


# Function to interact with the NPC and manage quest states
func interact_with_npc(body):
	if questState == 0:
		# Add the mission when the quest state is 0
		mission_id = body.mission_controller.add_mission(
			missionToGive["Mission Name"],
			missionToGive["Mission Item"],
			missionToGive["Mission Goal"],
			missionToGive["Mission Given By"],
			missionToGive["Mission Reward"],
			missionToGive["Reward Amount"]
		)
		body.talkBox.set_dialogue(getDialogue())
		questState = 1  # Update quest state to indicate progress
	elif questState == 1:
		if(body.mission_controller.is_mission_completed(mission_id)):
			questState = 2
			body.talkBox.set_dialogue(getDialogue())
			animated_sprite.play("finished_quest")
			
			for i in range(missionToGive["Reward Amount"]):
				body.mission_controller.collect_item(missionToGive["Mission Reward"]);
			
			questState = 3
		else:
			body.talkBox.set_dialogue(getDialogue())
		
	elif questState == 3:
		# Post-quest dialogue
		body.talkBox.set_dialogue(getDialogue())
	else:
		print("Invalid state.")

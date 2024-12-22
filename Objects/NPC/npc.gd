extends StaticBody2D

@export var start_quest = "Change me!"
@export var mid_quest = ["Change me in the middle!", "This is a second dialogue!"]
@export var end_quest = "Change me! But end this time."
@export var post_quest = "You've already finished my task. Get out!"
@export var npc_name = "Default"
@export var isTalkable = false

var questState = 0
var cycleIndex = 0

@export var missionToGive := {
	"Mission Name": "Default Mission",
	"Mission Item": 0, # Example: ID for the item required for the mission
	"Mission Goal": 1, # Example: The number of items needed
	"Mission Given By": "Default",
	"Mission Reward": "Gold", # Example: Type of reward
	"Reward Amount": 100, # Example: Amount of reward
	"Mission State": 1, # 1 = Not started, 2 = In progress, 3 = Completed
	"Currently Collected": 0
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

# Reference to mission controller, which should be an object managing all missions
var mission_controller = []

func add_mission(name, item_id, amount, given_by, reward := 0, reward_amount := 10) -> int:
	var mission = {
		"Mission Name": name,
		"Mission Item": item_id,
		"Mission Goal": amount,
		"Mission Given By": given_by,
		"Mission Reward": reward,
		"Reward Amount": reward_amount,
		"Mission State": 1,
		"Currently Collected": 0
	}
	
	mission_controller.append(mission)
	return mission_controller.size() - 1

# Function to interact with the NPC and manage quest states
func interact_with_npc(body):
	if questState == 0:
		# Add the mission when the quest state is 0
		var mission_id = body.mission_controller.add_mission(
			missionToGive["Mission Name"],
			missionToGive["Mission Item"],
			missionToGive["Mission Goal"],
			missionToGive["Mission Given By"],
			missionToGive["Mission Reward"],
			missionToGive["Reward Amount"]
		)
		# Log the mission ID
		print("Mission added with ID: ", mission_id)
		questState = 1  # Update quest state to indicate progress
	elif questState == 1:
		# Dialogue and mission progress for mid-quest
		print(getDialogue())
	elif questState == 2:
		# Quest is completed
		print(getDialogue())
	elif questState == 3:
		# Post-quest dialogue
		print(getDialogue())
	else:
		print("Invalid state.")

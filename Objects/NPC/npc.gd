extends StaticBody2D


@export var start_quest = "Change me!";

@export var mid_quest = ["Change me in the middle!", "This is a second dialogue!"];

@export var end_quest = "Change me! But end this time.";

@export var post_quest = "You've already finished my task. Get out!";

@export var npc_name = "Default";

@export var isTalkable = false;

var questState = 0;

var cycleIndex = 0;

	


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

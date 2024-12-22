extends RichTextLabel

var mission_controller := []
var previous_text = "";
@export var player: CharacterBody2D

func add_mission(name, item_id, amount, given_by, reward := 1, reward_amount := 10) -> int:
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
	
	update_mission_display()
	return mission_controller.size() - 1

func collect_item(itemID: int) -> bool:
	var mission_found = false
	
	for i in range(mission_controller.size()):
		var mission = mission_controller[i]
		
		# Check if the mission is active and the item matches
		if mission["Mission State"] == 1 and mission["Mission Item"] == itemID:
			mission_found = true
			mission["Currently Collected"] += 1
			
			# Ensure it does not exceed the mission goal
			if mission["Currently Collected"] > mission["Mission Goal"]:
				mission["Currently Collected"] = mission["Mission Goal"]
			
			# Check if the mission is now completed
			if is_mission_completed(i):
				finish_mission(i)
	
	update_mission_display()
	return mission_found



func finish_mission(missionID) -> void:
	if missionID < 0 or missionID >= mission_controller.size():
		print("Invalid mission ID:", missionID)
		return
	
	mission_controller[missionID]["Mission State"] = 2
	var mission = mission_controller[missionID]
	
	update_mission_display()
		
func is_mission_completed(missionID: int) -> bool:
	if missionID < 0 or missionID >= mission_controller.size():
		print("Invalid mission ID:", missionID)
		return false
	
	var mission = mission_controller[missionID]
	if mission["Currently Collected"] >= mission["Mission Goal"]:
		return true
	return false

func update_mission_display() -> void:
	var mission_text = "[b]Current Missions:[/b]\n"  # Add a bold header
	
	# Build the current mission text
	for i in range(mission_controller.size()):
		var mission = mission_controller[i]
		if mission["Mission State"] == 1:  # Display active missions
			mission_text += str(i + 1) + " - " + mission["Mission Name"] + " " + str(mission["Currently Collected"]) + "/" + str(mission["Mission Goal"]) + "\n"
		elif mission["Mission State"] == 2:  # Display completed missions
			mission_text += str(i + 1) + " - " + mission["Mission Name"] + " [Completed]\n"
	
	# Only highlight differences if previous_text exists
	if previous_text != "":
		# Find the longest length to avoid accessing out-of-bounds indices
		var min_length = min(mission_text.length(), previous_text.length())
		var diff_start = 0
		var diff_end = 0
		
		# Find where the text starts differing
		for i in range(min_length):
			if mission_text[i] != previous_text[i]:
				diff_start = i
				break
		
		# Find where the text ends differing
		for i in range(min_length, mission_text.length()):
			if(i == mission_text.length() or i == previous_text.length()):
				break
			if mission_text[i] != previous_text[i]:
				diff_end = i
				break
		
		# If a difference was found, highlight it in orange
		if diff_start != diff_end:
			previous_text = mission_text
			var pre_diff = mission_text.substr(0, diff_start)
			var diff_part = mission_text.substr(diff_start, diff_end - diff_start)
			var post_diff = mission_text.substr(diff_end, mission_text.length() - diff_end)
			mission_text = pre_diff + "[color=black]" + diff_part + "[/color]" + post_diff
	
	self.text = mission_text

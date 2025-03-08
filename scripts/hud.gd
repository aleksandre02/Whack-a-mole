extends Control

func set_time_label(value):
	$Timelabel.text = "Time:" + str(value)

func set_score_label(value):
	$Scorelabel.text = "Score:" +str(value)
	
func set_life_label(value):
	$Lives.text = "Lives: " + str(value)

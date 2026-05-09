@tool
extends AcceptDialog
class_name DupeDialog

@onready var anim_name : LineEdit = $VBoxContainer/HBoxContainer/AnimationName
@onready var track_path : LineEdit = $VBoxContainer/HBoxContainer2/TrackPath
@onready var track_type : OptionButton = $VBoxContainer/HBoxContainer3/TrackType
@onready var time_between : LineEdit = $VBoxContainer/HBoxContainer4/TimeBetween

var undo_redo : EditorUndoRedoManager
var anim_player : AnimationPlayer

func _ready():
	add_cancel_button("Cancel")

# keys_data is [ 0: time_first, 1: values, 2: eases ]
func dupe_keys(anim: Animation, track_id: int, key_count: int, keys_data: Array, time_sep: float):
	var next_time = keys_data[0] + time_sep
	
	# retime existing keys, skipping the first key
	if key_count > 1:
		for i in range(1, key_count):
			anim.track_set_key_time(track_id, i, next_time)
			next_time = next_time + time_sep
	
	# add new keys until hit the end of the animation
	var current_key = 0
	
	while next_time <= anim.length:
		anim.track_insert_key(track_id, next_time, keys_data[1][current_key], keys_data[2][current_key])
		
		current_key = current_key + 1
		if current_key == key_count: current_key = 0
		
		next_time = next_time + time_sep

func remove_keys(anim: Animation, track_id: int, orig_key_count: int, orig_times: Array):
	while anim.track_get_key_count(track_id) > orig_key_count:
		anim.track_remove_key(track_id, orig_key_count)
	
	# set the times back to original, since we retimed them. skip the first key
	if orig_key_count > 1:
		for i in range(1, orig_key_count):
			anim.track_set_key_time(track_id, i, orig_times[i])

func _on_confirmed():
	if anim_name.text.is_empty() or track_path.text.is_empty() or track_type.selected == -1 or time_between.text.is_empty():
		printerr("Anim name, track, track type, or time between is empty")
		return
	
	var anim = anim_player.get_animation(anim_name.text)
	if anim == null:
		printerr("Animation doesn't exist by name '%s'" % anim_name.text)
		return
	
	var track_id = anim.find_track(track_path.text, track_type.selected)
	if track_id == -1:
		printerr("Track not found in animation")
		return
	
	var count = anim.track_get_key_count(track_id)
	if count == 0:
		printerr("Track must have at least 1 key")
		return
	
	var time_sep = time_between.text.to_float()
	if time_sep <= 0.0:
		printerr("Time between must be a valid number above 0.0")
	
	var times = []
	var values = []
	var eases = []
	
	for i in count:
		times.append(anim.track_get_key_time(track_id, i))
		values.append(anim.track_get_key_value(track_id, i))
		eases.append(anim.track_get_key_transition(track_id, i))
	
	var data = [ times[0], values, eases ]
	
	# add to undo/redo history, which will automatically call dupe_keys for us
	undo_redo.create_action("Dupe anim keys")
	undo_redo.add_do_method(self, "dupe_keys", anim, track_id, count, data, time_sep)
	undo_redo.add_undo_method(self, "remove_keys", anim, track_id, count, times)
	undo_redo.commit_action()

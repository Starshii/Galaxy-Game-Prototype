@tool
extends EditorPlugin

var dialog : DupeDialog
var spatial_btn : Button
var canvas_btn : Button

var undo_redo : EditorUndoRedoManager
var anim_player : AnimationPlayer

func btn_pressed():
	dialog.undo_redo = undo_redo
	dialog.anim_player = anim_player
	dialog.popup_centered()

func selection_changed():
	var selection = get_editor_interface().get_selection().get_selected_nodes()
	
	if selection.size() == 1 and selection[0] is AnimationPlayer:
		anim_player = selection[0]
		spatial_btn.show()
		canvas_btn.show()
	else:
		spatial_btn.hide()
		canvas_btn.hide()

func _enter_tree():
	undo_redo = get_undo_redo()
	
	spatial_btn = Button.new()
	spatial_btn.text = "Dupe anim keys"
	spatial_btn.pressed.connect(btn_pressed)
	canvas_btn = Button.new()
	canvas_btn.text = "Dupe anim keys"
	canvas_btn.pressed.connect(btn_pressed)
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, spatial_btn)
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, canvas_btn)
	
	spatial_btn.hide()
	canvas_btn.hide()
	
	dialog = preload("res://addons/dupeanimkeys/dialog.tscn").instantiate()
	get_editor_interface().get_base_control().add_child(dialog)
	
	get_editor_interface().get_selection().selection_changed.connect(self.selection_changed)

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, spatial_btn)
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, canvas_btn)
	if spatial_btn: spatial_btn.free()
	if canvas_btn: canvas_btn.free()

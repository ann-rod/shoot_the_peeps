extends Node2D

func handle_jet_spawned(jet, pos, dir):
	add_child(jet)
	jet.global_position = pos
	jet.set_direction(dir)

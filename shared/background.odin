package shared

B_Tiles_Enum :: enum {
	Plain,
	Desert,
	Water,
	Snow,
}


Resource_Enum :: enum {
	Stone,
	Ore,
	Precious_Ore,
	Fibre,
	Hide,
	Food,
}

Resource_Level_Enum :: enum {
	Lvl_1,
	Lvl_2,
	Lvl_3,
	Lvl_4,
	Lvl_5,
}

Tile :: struct {
	b_type:  B_Tiles_Enum,
	r_type:  Resource_Enum,
	r_level: Resource_Level_Enum,
}

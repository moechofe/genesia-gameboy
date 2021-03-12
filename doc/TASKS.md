- ☑️ **Design a map data**

	Proposal #1:

	Map cells takes 2.5x2.5 GB tiles
	The screen can show 6.33x5.67 cells
	Map slots takes 7x7 cells
	Map takes 4x4 slots
	Map takes 28x28 cells + 4 for borders

	Map takes 95x95 tiles

		= 32 cells * 2 tiles (64 tiles)
		+ 31 cells * 1 tile (31 tiles)

	95x95 tiles

	🟥 Map takes 9025 Kibi for storing the tiles index for the BG

	Just for one map, that's a lot.

	Proposal #2:

	✅ From proposal #1 only store the cells	

- **Implement a map renderer**

	- need two coords: background and map

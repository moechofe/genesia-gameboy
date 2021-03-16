- ☑️ **Design a map data**

	**Proposal #1:**

	Map cells takes 2.5x2.5 GB tiles
	The screen can show 6.33x5.67 cells
	Map slots takes 7x7 cells
	Map takes 4x4 slots
	Map takes 28x28 cells

		+ plains: 28 cells * 2 tiles (56 tiles)
		+ borders: 27 cells * 1 tile (27 tiles)
		= 83 tiles

		+ 3 in each direction (6)
		= 89

	Map takes 89x89 tiles

		= 7,921 Kibi

	✅ Map takes 7921 Kibi for storing the tiles index for the BG

	Just for one map, that's a lot.
	I should try, it will greatly reduce the quantity of code to write and debug:

	1. the code that use the cell data and add a pre-determined random value.
	2. the code that detect if the tile is a plain cell or a border cell.

	Also, It give a few bytes to store other informations

	**Proposal #2:**

	🟥 From proposal #1 only store the cells

- **Implement a map renderer**

	- need two coords: background and map

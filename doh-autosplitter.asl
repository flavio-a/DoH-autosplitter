state("Dungeons of Hinterberg", "v1.0")
{
	bool isLoading : "GameAssembly.dll", 0x035FA4F0, 0xB8, 0x158, 0xB0, 0x70, 0x90, 0x160, 0xB10;
	uint dungeonsCounter: "GameAssembly.dll", 0x035FA4F0, 0x40, 0xB8, 0x98, 0x38, 0xB0, 0x70, 0x18;
}

startup
{
	settings.Add("split_on_dungeons", true, "Split when completing a dungeon");
	settings.SetToolTip("split_on_dungeons", "Split whenever the completed dungeons counter increases. This usually works but may give issues sometimes while loading other saves");

	// Keeps track of the max value of dungeonsCounter
	vars.dungeonsCounterMax = 0;
	vars.dungeonsCounterIncreased = false;
}

init
{
	// Eventually I may want to implement v1.1
	version = "v1.0";
}

update
{
	// General purpose check if a load just started
	vars.loadStarted = !old.isLoading && current.isLoading;
	// Keeps track of the max dungeonsCounter and signal if it's increased
	if (!vars.dungeonsCounterIncreased && current.dungeonsCounter == vars.dungeonsCounterMax + 1) {
		vars.dungeonsCounterMax = current.dungeonsCounter;
		vars.dungeonsCounterIncreased = true;
	}
	else {
		vars.dungeonsCounterIncreased = false;
	}
	return true;
}

isLoading
{
	return current.isLoading;
}

start
{
	// Start on first load
	return vars.loadStarted;
}

split
{
	// Split on dungeon stamps (and Hinterwald West extra day idk why)
	if (settings["split_on_dungeons"] && vars.dungeonsCounterIncreased) {
		print("[DoH] dungeonsCounter = " + current.dungeonsCounter.ToString());
		return true;
	}
	return false;
}

onStart
{
	// Reset dungeonsCounterMax every run
	vars.dungeonsCounterMax = current.dungeonsCounter;
	vars.dungeonsCounterIncreased = false;
}

 state("Fallout3","GOG")
{
	bool loading : 0xC76CE8;
	bool introDone : 0xC771D0;
	float speed : 0x0000CACC, 0x0 ,0x28, 0x1A4, 0xE8, 0x60, 0x138, 0x344;
    int quest: 0xC6F2F8 , 0x4;
}
state("Fallout3","Steam")
{
	bool introDone : 0xE3AFCC;
	bool loading : 0xE3ABBC;
	float speed: 0x00D13F68, 0x1E0, 0x1BC, 0xB4, 0x8, 0x60, 0x138, 0x344;
	int quest: 0x00E23230, 0x4;
}
state("Fallout3","SteamAnniversaryEdition")
{
	bool introDone : 0xE3AFCC;
	bool loading : 0xE3ABBC;
	float speed: 0x00B4BFB0, 0xB4, 0x8, 0x1A4, 0xE8, 0x60, 0x138, 0x344;
	int quest: 0x00E23230, 0x4;
}		
	
init
{
    switch (modules.First().ModuleMemorySize) { // This is to know what version you are playing on
        case 17952768: version = "Steam";
            break;
        case 16166912: version = "GOG"; 
            break;
		case 16171008: version = "SteamAnniversaryEdition";
			break;
        default:        version = "Steam"; 
            break;
    }
}



startup
  {
	String speedometer;
	String questcounter;
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });


	vars.SetTextComponent2 = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });



    // Declares the name of the text component
    settings.Add("Quest Counter", false, "Quest Counter");	
    settings.Add("Speed", false, "Speed");	
}


update
{
    vars.isLoading = false;
	if ((current.loading) || (!current.introDone)) {
        vars.isLoading = true;
    }
	
	if (settings["Speed"]) 
	{
		if(vars.isLoading == false)
		{
			current.speedometer = current.speed.ToString("000.0000");
			vars.SetTextComponent("Speed:", (current.speedometer));
		}

	}
	if (settings["Quest Counter"]) 
	{
		current.questcounter = current.quest.ToString("0");
		vars.SetTextComponent("Quests:", (current.questcounter)); 
	}
}

isLoading
{
    return vars.isLoading;
}
exit
{
    timer.IsGameTimePaused = true;
}

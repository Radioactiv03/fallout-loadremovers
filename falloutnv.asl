state("FalloutNV")
{
	bool loading : 0xDDA4EC;
	//pre xnvse patch - bool introDone : 0xDDA590;
	bool introDone : 0xDDAC70;
	float speed : 0x00DCB4A8, 0x30, 0xA4, 0x8, 0x68, 0x46C, 0x140, 0x514;
	byte quest: 0x00DC6D50, 0x4;
}



startup
  {
	String speedometer;
	String questcounter;

    //creates text components for quest counter and speedometer
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



    settings.Add("Quest Counter", false, "Quest Counter");	
    settings.Add("Speed", false, "Speed");
    settings.Add("Autosplitter", false, "Autosplitter");	
    settings.SetToolTip("Autosplitter", "Causes timer to split when the quest counter is the same as the quest number in your splits surrounded by () eg: (1) Infinite Dash\n Will not split if anything else surrounds the number ");

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

split
{
    //splits when current split contains (x) where x is the current number of completed quests
    if(timer.CurrentSplit.Name.ToLower().Contains("("+current.questcounter+")") && (settings["Autosplitter"]))
    {
        return true;
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

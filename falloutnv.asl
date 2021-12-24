state("FalloutNV")
{
    	bool loading : 0xDDA4EC;
    	bool introDone : 0xDDA590;
	float speed : 0x00DCB4A8, 0x30, 0xA4, 0x8, 0x68, 0x46C, 0x140, 0x514;
}



startup
  {
	String speedometer;
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
// Declares the name of the text component
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
		}
		vars.SetTextComponent("Speed:", (current.speedometer)); 
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

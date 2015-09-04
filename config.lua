
local mediaRes = display.pixelWidth  / 480

application =
{

	content =
	{
		width = display.pixelWidth / mediaRes,
        height = display.pixelHeight / mediaRes
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}

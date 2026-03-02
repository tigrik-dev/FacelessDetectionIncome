class UIListener_FacelessIncome extends UIScreenListener;

event OnInit(UIScreen Screen)
{
    local UIOutpostManagement OutpostScreen;

    if (Screen != none && Screen.IsA('UIOutpostManagement'))
    {
		`LOG("Screen is UIOutpostManagement",, 'FacelessDetectionIncome');
        OutpostScreen = UIOutpostManagement(Screen);

        AddFacelessIncome(OutpostScreen);
    }
}

function AddFacelessIncome(UIOutpostManagement Screen)
{
    local XComGameState_LWOutpost Outpost;
    local XComGameStateHistory History;
    local float IncomeFaceless;
	local string FormattedIncomeFaceless;
    local UIScrollingText IncomeFacelessStr;

    History = `XCOMHISTORY;
    Outpost = XComGameState_LWOutpost(
        History.GetGameStateForObjectID(Screen.OutpostRef.ObjectID)
    );

	`LOG("AddFacelessIncome. Outpost assigned",, 'FacelessDetectionIncome');

    if (Outpost == none)
        return;

	`LOG("AddFacelessIncome. Outpost is not null",, 'FacelessDetectionIncome');
    IncomeFaceless = class'X2FacelessIncomeHelper'.static.GetProjectedFacelessIncome(Outpost);
	FormattedIncomeFaceless = class'UIUtilities'.static.FormatFloat(IncomeFaceless, 1);

	`LOG("AddFacelessIncome. IncomeFaceless assigned",, 'FacelessDetectionIncome');

	panelW = Screen.panelW;          // must use LWOTC’s panelW
	BorderPadding = 15;
	NextY = Screen.ListTitle.Y + Screen.ListTitle.Height;

	if (Screen.IncomeRecruitStr == none)
		return;

	IncomeFacelessStr = Screen.MainPanel.Spawn(class'UIScrollingText', Screen.MainPanel);
	IncomeFacelessStr.bAnimateOnInit = false;
	IncomeFacelessStr.bIsNavigable = false;

	IncomeFacelessStr.InitScrollingText(
		'Outpost_FacelessIncome',
		"",
		Screen.IncomeRecruitStr.Width,
		Screen.IncomeRecruitStr.X,
		Screen.IncomeRecruitStr.Y + 28.0
	);

	IncomeFacelessStr.SetHTMLText("<p align='RIGHT'><font size='24' color='#fef4cb'>Faceless Detection: " $FormattedIncomeFaceless $ "</font></p>");
	IncomeFacelessStr.SetAlpha(67.1875);

	`LOG("AddFacelessIncome. InitScrollingText done",, 'FacelessDetectionIncome');

	IncomeFacelessStr.SetHTMLText(
		"<p align='RIGHT'><font size='24' color='#fef4cb'>Faceless Detection: " $ 
		IncomeFaceless $ "</font></p>"
	);

	`LOG("AddFacelessIncome. SetHTMLText done",, 'FacelessDetectionIncome');

	IncomeFacelessStr.SetAlpha(67.1875);

	`LOG("AddFacelessIncome. SetAlpha done",, 'FacelessDetectionIncome');
}
class X2FacelessIncomeHelper extends Object;

static function float GetProjectedFacelessIncome(XComGameState_LWOutpost OutpostState)
{
    local float NewIncome;
    local XComGameState_Unit Liaison;
    local StateObjectReference LiaisonRef;
    local int Rank, AbilityCount;
    local array<name> FacelessChanceReductionAbilities;
    local name FacelessReductionAbilityName;

	`LOG("GetProjectedFacelessIncome. Start",, 'FacelessDetectionIncome');

    LiaisonRef = OutpostState.GetLiaison();
	`LOG("GetProjectedFacelessIncome. LiaisonRef defined",, 'FacelessDetectionIncome');

    Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));
	`LOG("GetProjectedFacelessIncome. Liaison defined",, 'FacelessDetectionIncome');

    if (Liaison == none || !Liaison.IsSoldier())
        return 0.0f;

	`LOG("GetProjectedFacelessIncome. Liaison is not none and is a soldier",, 'FacelessDetectionIncome');
    // ?? NOTICE: Faceless count check REMOVED

    switch (Liaison.GetSoldierClassTemplateName())
    {
        case 'PsiOperative':
			`LOG("GetProjectedFacelessIncome. Liaison is Psi Operative",, 'FacelessDetectionIncome');
            Rank = Liaison.GetRank();
			`LOG("GetProjectedFacelessIncome. Rank assigned",, 'FacelessDetectionIncome');
            Rank = Clamp(Rank, 0, class'X2LWActivityDetectionCalc_Rendezvous'.default.LIAISON_MISSION_INCOME_PER_RANK_PSI.Length - 1);
			`LOG("GetProjectedFacelessIncome. Rank clamped",, 'FacelessDetectionIncome');
            NewIncome = class'X2LWActivityDetectionCalc_Rendezvous'.default.LIAISON_MISSION_INCOME_PER_RANK_PSI[Rank];
			`LOG("GetProjectedFacelessIncome. NewIncome assigned",, 'FacelessDetectionIncome');
            break;

        default:
			`LOG("GetProjectedFacelessIncome. Liaison is NOT a Psi Operative",, 'FacelessDetectionIncome');
            Rank = Liaison.GetRank();
			`LOG("GetProjectedFacelessIncome. Rank assigned",, 'FacelessDetectionIncome');
            Rank = Clamp(Rank, 0, class'X2LWActivityDetectionCalc_Rendezvous'.default.LIAISON_MISSION_INCOME_PER_RANK.Length - 1);
			`LOG("GetProjectedFacelessIncome. Rank clamped",, 'FacelessDetectionIncome');
            NewIncome = class'X2LWActivityDetectionCalc_Rendezvous'.default.LIAISON_MISSION_INCOME_PER_RANK[Rank];
			`LOG("GetProjectedFacelessIncome. NewIncome assigned",, 'FacelessDetectionIncome');
            break;
    }

    if (class'LWOfficerUtilities'.static.IsOfficer(Liaison))
    {
		`LOG("GetProjectedFacelessIncome. Liaison is an Officer",, 'FacelessDetectionIncome');
        Rank = class'LWOfficerUtilities'.static.GetOfficerComponent(Liaison).GetOfficerRank();
		`LOG("GetProjectedFacelessIncome. Rank assigned",, 'FacelessDetectionIncome');
        Rank = Clamp(Rank, 0, class'X2LWActivityDetectionCalc_Rendezvous'.default.LIAISON_MISSION_INCOME_BONUS_PER_RANK_OFFICER.Length - 1);
		`LOG("GetProjectedFacelessIncome. Rank clamped",, 'FacelessDetectionIncome');
        NewIncome += class'X2LWActivityDetectionCalc_Rendezvous'.default.LIAISON_MISSION_INCOME_BONUS_PER_RANK_OFFICER[Rank];
		`LOG("GetProjectedFacelessIncome. NewIncome assigned",, 'FacelessDetectionIncome');
    }

    FacelessChanceReductionAbilities =
        class'XComGameState_LWOutpost'.default.FACELESS_CHANCE_REDUCTION_ABILITIES.Length > 0
        ? class'XComGameState_LWOutpost'.default.FACELESS_CHANCE_REDUCTION_ABILITIES
        : class'XComGameState_LWOutpost'.default.DEFAULT_FACELESS_REDUCTION_CHANCE_ABILITIES;

    AbilityCount = 0;
    foreach FacelessChanceReductionAbilities(FacelessReductionAbilityName)
    {
        if (Liaison.HasAbilityFromAnySource(FacelessReductionAbilityName))
        {
            AbilityCount += 1;
        }
    }

    NewIncome *= 1.0 + (AbilityCount * 0.1);
	`LOG("GetProjectedFacelessIncome. NewIncome multiplied",, 'FacelessDetectionIncome');

	// Don't adjust for geoscape ticks - makes it easier to correlate the value with the LIAISON_MISSION_INCOME_PER_RANK, etc. config values
    // NewIncome *= float(class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES) / 24.0;

    return NewIncome;
}
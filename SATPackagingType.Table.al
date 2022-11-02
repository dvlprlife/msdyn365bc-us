﻿table 27025 "SAT Packaging Type"
{
    DataPerCompany = false;
    DrillDownPageID = "SAT Packaging Types";
    LookupPageID = "SAT Packaging Types";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


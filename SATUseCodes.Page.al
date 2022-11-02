page 27042 "SAT Use Codes"
{
    Caption = 'SAT Use Codes';
    PageType = List;
    SourceTable = "SAT Use Code";
    ApplicationArea = BasicMX;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SAT Use Code"; "SAT Use Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for this entry according to the SAT use code definition.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description for this entry according to the SAT use code definition.';
                }
            }
        }
    }

    actions
    {
    }
}


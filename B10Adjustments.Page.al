page 10240 "B10 Adjustments"
{
    Caption = 'B10 Adjustments';
    PageType = List;
    SourceTable = "B10 Adjustment";

    layout
    {
        area(content)
        {
            repeater(Control1480000)
            {
                ShowCaption = false;
                field(Date; Date)
                {
                    ApplicationArea = BasicMX;
                    ToolTip = 'Specifies the effective date of the B-10 adjustment rate.';
                }
                field("Adjustment Amount"; "Adjustment Amount")
                {
                    ApplicationArea = BasicMX;
                    ToolTip = 'Specifies the published B-10 amount for the effective date.';
                }
            }
        }
    }

    actions
    {
    }
}


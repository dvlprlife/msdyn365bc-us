codeunit 130401 "CAL Test Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        Window: Dialog;
        Mode: Option Test,Publish;
        AddingTestCodeunitsMsg: Label 'Adding Test Codeunits @1@@@@@@@', Locked = true;
        SelectTestsToRunQst: Label 'Active &Line,Active &Codeunit,&All', Locked = true;
        SelectTestsToImportQst: Label '&Select Test Codeunits,&All Test Codeunits', Locked = true;
        SelectTestsToImportFromTCMQst: Label '&Select Test Codeunits,&All Test Codeunits,Get Tests Codeunits based on Selected &Objects', Locked = true;
        SelectCodeunitsToRunQst: Label ',Active &Codeunit,&All', Locked = true;
        DefaultTxt: Label 'DEFAULT', Locked = true;
        DefaultSuiteTxt: Label 'Default Suite - Autogenerated', Locked = true;
        ObjectNotCompiledErr: Label 'Object not compiled.', Locked = true;
        WindowUpdateDateTime: DateTime;
        NoOfRecords: Integer;
        i: Integer;
        AddingTestsBasedOnChurnMsg: Label 'Adding %1 test codeunits based on churn @1@@@@@@@', Locked = true;
        NoModifiedObjectsFoundMsg: Label 'No modified objects found.', Locked = true;

    procedure SETPUBLISHMODE()
    begin
        Mode := Mode::Publish;
    end;

    procedure SETTESTMODE()
    begin
        Mode := Mode::Test;
    end;

    procedure ISPUBLISHMODE(): Boolean
    begin
        exit(Mode = Mode::Publish);
    end;

    procedure ISTESTMODE(): Boolean
    begin
        exit(Mode = Mode::Test);
    end;

    procedure DoesTestCodeunitExist(ID: Integer): Boolean
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.Reset();
        AllObjWithCaption.SetRange("Object ID", ID);
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Codeunit);
        AllObjWithCaption.SetRange("Object Subtype", 'Test');
        exit(not AllObjWithCaption.IsEmpty);
    end;

    [Scope('OnPrem')]
    procedure GetTestCodeunitsSelection(CALTestSuite: Record "CAL Test Suite")
    var
        CALTestLine: Record "CAL Test Line";
        AllObjWithCaption: Record AllObjWithCaption;
        TempAllObjWithCaption: Record AllObjWithCaption temporary;
        CALTestCoverageMap: Record "CAL Test Coverage Map";
        CALTestGetCodeunits: Page "CAL Test Get Codeunits";
        Selection: Integer;
    begin
        if CALTestCoverageMap.IsEmpty() then
            Selection := StrMenu(SelectTestsToImportQst, 1)
        else
            Selection := StrMenu(SelectTestsToImportFromTCMQst, 1);

        if Selection = 0 then
            exit;

        case Selection of
            1:
                begin
                    CALTestGetCodeunits.LookupMode := true;
                    if CALTestGetCodeunits.RunModal() = ACTION::LookupOK then begin
                        CALTestGetCodeunits.SetSelectionFilter(AllObjWithCaption);
                        AddTestCodeunits(CALTestSuite, AllObjWithCaption);
                    end;
                end;
            2:
                begin
                    CALTestLine.SetRange("Test Suite", CALTestSuite.Name);
                    CALTestLine.DeleteAll(true);
                    if GetTestCodeunits(TempAllObjWithCaption) then
                        RefreshSuite(CALTestSuite, TempAllObjWithCaption);
                end;
            3:
                GetTestCodeunitsForSelectedObjects(CALTestSuite.Name);
        end;
    end;

    local procedure GetTestCodeunits(var ToAllObjWithCaption: Record AllObjWithCaption): Boolean
    var
        FromAllObjWithCaption: Record AllObjWithCaption;
    begin
        with ToAllObjWithCaption do begin
            FromAllObjWithCaption.SetRange("Object Type", "Object Type"::Codeunit);
            FromAllObjWithCaption.SetRange("Object Subtype", 'Test');
            if FromAllObjWithCaption.Find('-') then
                repeat
                    ToAllObjWithCaption := FromAllObjWithCaption;
                    Insert();
                until FromAllObjWithCaption.Next() = 0;
        end;

        exit(ToAllObjWithCaption.Find('-'));
    end;

    local procedure GetTestCodeunitsForObjects(var AllObj: Record AllObj; CALTestSuiteName: Code[10])
    var
        TempMissingCUId: Record "Integer" temporary;
        TempTestCodeunitID: Record "Integer" temporary;
        CALTestMissingCodeunits: Page "CAL Test Missing Codeunits";
        TestLineNo: Integer;
        TestCodeunitsNumber: Integer;
    begin
        AllObj.SetFilter("Object Type", '<>%1', AllObj."Object Type"::TableData);
        if AllObj.FindSet() then begin
            TestCodeunitsNumber := GetTotalTestCodeunitIDs(AllObj, TempTestCodeunitID);
            OpenWindow(StrSubstNo(AddingTestsBasedOnChurnMsg, TestCodeunitsNumber), TestCodeunitsNumber);
            TestLineNo := GetLastTestLineNo(CALTestSuiteName);
            if TempTestCodeunitID.FindSet() then
                repeat
                    if DoesTestCodeunitExist(TempTestCodeunitID.Number) then begin
                        if not TestLineExists(CALTestSuiteName, TempTestCodeunitID.Number) then begin
                            TestLineNo := TestLineNo + 10000;
                            AddTestLine(CALTestSuiteName, TempTestCodeunitID.Number, TestLineNo);
                            UpdateWindow();
                        end
                    end else begin
                        TempMissingCUId.Number := TempTestCodeunitID.Number;
                        TempMissingCUId.Insert();
                    end;
                until TempTestCodeunitID.Next() = 0;
            Window.Close();
        end else
            Message(NoModifiedObjectsFoundMsg);

        if not TempMissingCUId.IsEmpty() then begin
            Commit();
            CALTestMissingCodeunits.Initialize(TempMissingCUId, CALTestSuiteName);
            CALTestMissingCodeunits.RunModal();
        end;
    end;

    local procedure GetTestCodeunitsForSelectedObjects(CALTestSuiteName: Code[10])
    var
        AllObj: Record AllObj;
        ALTestObjectsToSelect: Page "AL Test Objects To Select";
    begin
        ALTestObjectsToSelect.LookupMode := true;
        ALTestObjectsToSelect.SetTableView(AllObj);
        if ALTestObjectsToSelect.RunModal() = ACTION::LookupOK then begin
            ALTestObjectsToSelect.SetSelectionFilter(AllObj);
            GetTestCodeunitsForObjects(AllObj, CALTestSuiteName);
        end;
    end;

    local procedure GetTotalTestCodeunitIDs(var AllObj: Record AllObj; var TestCodeunitID: Record "Integer"): Integer
    var
        CALTestCoverageMap: Record "CAL Test Coverage Map";
    begin
        repeat
            CALTestCoverageMap.Reset();
            CALTestCoverageMap.SetRange("Object ID", AllObj."Object ID");
            CALTestCoverageMap.SetRange("Object Type", AllObj."Object Type");
            if CALTestCoverageMap.FindSet() then
                repeat
                    if not TestCodeunitID.Get(CALTestCoverageMap."Test Codeunit ID") then begin
                        TestCodeunitID.Number := CALTestCoverageMap."Test Codeunit ID";
                        TestCodeunitID.Insert();
                    end;
                until CALTestCoverageMap.Next() = 0;
        until AllObj.Next() = 0;
        exit(TestCodeunitID.Count);
    end;

    local procedure GetLastTestLineNo(TestSuiteName: Code[10]) LineNo: Integer
    var
        CALTestLine: Record "CAL Test Line";
    begin
        CALTestLine.SetRange("Test Suite", TestSuiteName);
        if CALTestLine.FindLast() then
            LineNo := CALTestLine."Line No.";
    end;

    [Scope('OnPrem')]
    procedure CreateNewSuite(var NewSuiteName: Code[10])
    var
        CALTestSuite: Record "CAL Test Suite";
    begin
        with CALTestSuite do begin
            NewSuiteName := DefaultTxt;
            Init();
            Validate(Name, NewSuiteName);
            Validate(Description, DefaultSuiteTxt);
            Validate(Export, false);
            Insert(true);
        end;
    end;

    local procedure RefreshSuite(CALTestSuite: Record "CAL Test Suite"; var AllObjWithCaption: Record AllObjWithCaption)
    var
        CALTestLine: Record "CAL Test Line";
        LineNo: Integer;
    begin
        with CALTestLine do begin
            LineNo := LineNo + 10000;

            Init();
            Validate("Test Suite", CALTestSuite.Name);
            Validate("Line No.", LineNo);
            Validate("Line Type", "Line Type"::Group);
            Validate(Name, DefaultSuiteTxt);
            Validate(Run, true);
            Insert(true);

            AddTestCodeunits(CALTestSuite, AllObjWithCaption);
        end;
    end;

    procedure AddTestCodeunits(CALTestSuite: Record "CAL Test Suite"; var AllObjWithCaption: Record AllObjWithCaption)
    var
        TestLineNo: Integer;
    begin
        if AllObjWithCaption.Find('-') then begin
            TestLineNo := GetLastTestLineNo(CALTestSuite.Name);
            OpenWindow(AddingTestCodeunitsMsg, AllObjWithCaption.Count);
            repeat
                TestLineNo := TestLineNo + 10000;
                AddTestLine(CALTestSuite.Name, AllObjWithCaption."Object ID", TestLineNo);
                UpdateWindow();
            until AllObjWithCaption.Next() = 0;
            Window.Close();
        end;
    end;

    [Scope('OnPrem')]
    procedure AddMissingTestCodeunits(var TestCodeunitIds: Record "Integer"; TestSuiteName: Code[10])
    var
        AllObj: Record AllObj;
        TestLineNo: Integer;
    begin
        TestLineNo := GetLastTestLineNo(TestSuiteName);
        OpenWindow(StrSubstNo(AddingTestsBasedOnChurnMsg, TestCodeunitIds.Count), TestCodeunitIds.Count);

        repeat
            AllObj.SetRange("Object Type", AllObj."Object Type"::Codeunit);
            AllObj.SetRange("Object ID", TestCodeunitIds.Number);
            if AllObj.FindFirst() then begin
                TestLineNo := TestLineNo + 10000;
                AddTestLine(TestSuiteName, AllObj."Object ID", TestLineNo);
                UpdateWindow();
                TestCodeunitIds.Delete();
            end;
        until TestCodeunitIds.Next() = 0;

        Window.Close();
    end;

    local procedure AddTestLine(TestSuiteName: Code[10]; TestCodeunitId: Integer; LineNo: Integer)
    var
        CALTestLine: Record "CAL Test Line";
        AllObj: Record AllObj;
        CodeunitIsValid: Boolean;
    begin
        with CALTestLine do begin
            if TestLineExists(TestSuiteName, TestCodeunitId) then
                exit;

            Init();
            Validate("Test Suite", TestSuiteName);
            Validate("Line No.", LineNo);
            Validate("Line Type", "Line Type"::Codeunit);
            Validate("Test Codeunit", TestCodeunitId);
            Validate(Run, true);

            Insert(true);

            AllObj.SetRange("Object Type", AllObj."Object Type"::Codeunit);
            AllObj.SetRange("Object ID", TestCodeunitId);
            if Format(AllObj."App Package ID") <> '' then
                CodeunitIsValid := true;

            if not CodeunitIsValid then
                CodeunitIsValid := AllObj.FindFirst();

            if CodeunitIsValid then begin
                SETPUBLISHMODE();
                SetRecFilter();
                CODEUNIT.Run(CODEUNIT::"CAL Test Runner", CALTestLine);
            end else begin
                Validate(Result, Result::Failure);
                Validate("First Error", ObjectNotCompiledErr);
                Modify(true);
            end;
        end;
    end;

    local procedure TestLineExists(TestSuiteName: Code[10]; TestCodeunitId: Integer): Boolean
    var
        CALTestLine: Record "CAL Test Line";
    begin
        CALTestLine.SetRange("Test Suite", TestSuiteName);
        CALTestLine.SetRange("Test Codeunit", TestCodeunitId);
        exit(not CALTestLine.IsEmpty);
    end;

    procedure ExtendTestCoverage(TestCodeunitId: Integer)
    var
        CodeCoverage: Record "Code Coverage";
        CALTestCoverageMap: Record "CAL Test Coverage Map";
    begin
        CodeCoverage.SetRange("Line Type", CodeCoverage."Line Type"::Object);
        if CodeCoverage.FindSet() then
            repeat
                if not CALTestCoverageMap.Get(TestCodeunitId, CodeCoverage."Object Type", CodeCoverage."Object ID") then begin
                    CALTestCoverageMap.Init();
                    CALTestCoverageMap."Test Codeunit ID" := TestCodeunitId;
                    CALTestCoverageMap."Object Type" := CodeCoverage."Object Type";
                    CALTestCoverageMap."Object ID" := CodeCoverage."Object ID";
                    CALTestCoverageMap.Insert();
                end;
            until CodeCoverage.Next() = 0;
    end;

    local procedure GetLineNoFilter(CALTestLine: Record "CAL Test Line"; Selection: Option ,"Function","Codeunit") LineNoFilter: Text
    var
        NoOfFunctions: Integer;
    begin
        LineNoFilter := '';
        case Selection of
            Selection::"Function":
                begin
                    CALTestLine.TestField("Line Type", CALTestLine."Line Type"::"Function");
                    LineNoFilter := Format(CALTestLine."Line No.");
                    CALTestLine.Reset();
                    CALTestLine.SetRange("Test Suite", CALTestLine."Test Suite");
                    CALTestLine.SetRange("Test Codeunit", CALTestLine."Test Codeunit");
                    CALTestLine.SetFilter("Function", 'OnRun|%1', '');
                    CALTestLine.FindSet();
                    repeat
                        LineNoFilter := LineNoFilter + '|' + Format(CALTestLine."Line No.");
                    until CALTestLine.Next() = 0;
                end;
            Selection::Codeunit:
                LineNoFilter :=
                  StrSubstNo('%1..%2', CALTestLine.GetMinCodeunitLineNo(), CALTestLine.GetMaxCodeunitLineNo(NoOfFunctions));
        end;
    end;

    procedure RunSelected(var CurrCALTestLine: Record "CAL Test Line")
    var
        CALTestLine: Record "CAL Test Line";
        CodeunitIsMarked: Boolean;
        LastCodeunitID: Integer;
        LineNoFilter: Text;
        Selection: Option ,"Function","Codeunit";
        Separator: Text[1];
    begin
        if CurrCALTestLine.IsEmpty() then
            exit;
        CALTestLine.Copy(CurrCALTestLine);
        Separator := '';
        LineNoFilter := '';
        CALTestLine.FindSet();
        repeat
            if CALTestLine."Line Type" = CALTestLine."Line Type"::Codeunit then begin
                LineNoFilter := LineNoFilter + Separator + GetLineNoFilter(CALTestLine, Selection::Codeunit);
                LastCodeunitID := CALTestLine."Test Codeunit";
                CodeunitIsMarked := true;
            end else
                if LastCodeunitID <> CALTestLine."Test Codeunit" then begin
                    LastCodeunitID := CALTestLine."Test Codeunit";
                    LineNoFilter := LineNoFilter + Separator + GetLineNoFilter(CALTestLine, Selection::"Function");
                    CodeunitIsMarked := false;
                end else
                    if not CodeunitIsMarked then
                        LineNoFilter := LineNoFilter + Separator + Format(CALTestLine."Line No.");
            Separator := '|';
        until CALTestLine.Next() = 0;

        CALTestLine.Reset();
        CALTestLine.SetRange("Test Suite", CurrCALTestLine."Test Suite");
        CALTestLine.SetFilter("Line No.", LineNoFilter);
        RunSuite(CALTestLine, true);
    end;

    procedure RunSuiteYesNo(var CurrCALTestLine: Record "CAL Test Line")
    var
        CALTestLine: Record "CAL Test Line";
        Selection: Option ,"Function","Codeunit";
        LineNoFilter: Text;
    begin
        if CurrCALTestLine.IsEmpty() then
            exit;
        CALTestLine.Copy(CurrCALTestLine);
        if CALTestLine."Line Type" = CALTestLine."Line Type"::Codeunit then
            Selection := StrMenu(SelectCodeunitsToRunQst, 2)
        else
            Selection := StrMenu(SelectTestsToRunQst, 1);

        if Selection = 0 then
            exit;

        LineNoFilter := GetLineNoFilter(CALTestLine, Selection);
        if LineNoFilter <> '' then
            CALTestLine.SetFilter("Line No.", LineNoFilter);
        RunSuite(CALTestLine, true);
    end;

    procedure RunSuite(var CALTestLine: Record "CAL Test Line"; IsTestMode: Boolean)
    var
        CALTestLine2: Record "CAL Test Line";
        CALTestRunner: Codeunit "CAL Test Runner";
    begin
        if IsTestMode() then begin
            SETTESTMODE();
            CALTestRunner.Run(CALTestLine);
        end else begin
            SETPUBLISHMODE();
            CALTestLine2.Copy(CALTestLine);
            CALTestLine2.SetRange("Line No.", CALTestLine."Line No.");
            CALTestLine2.TestField("Test Codeunit");
            CALTestLine2.TestField("Function", '');

            CALTestLine.DeleteChildren();
            CALTestLine2.DeleteChildren();

            CALTestRunner.Run(CALTestLine2);
        end;
        Clear(CALTestRunner);
    end;

    local procedure OpenWindow(DisplayText: Text; NoOfRecords2: Integer)
    begin
        i := 0;
        NoOfRecords := NoOfRecords2;
        WindowUpdateDateTime := CurrentDateTime;
        Window.Open(DisplayText);
    end;

    local procedure UpdateWindow()
    begin
        i := i + 1;
        if CurrentDateTime - WindowUpdateDateTime >= 1000 then begin
            WindowUpdateDateTime := CurrentDateTime;
            Window.Update(1, Round(i / NoOfRecords * 10000, 1));
        end;
    end;

    procedure EnableTestToRun()
    var
        CALTestEnabledCodeunit: Record "CAL Test Enabled Codeunit";
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        CALTestEnabledCodeunit.DeleteAll();
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Codeunit);
        AllObjWithCaption.SetRange("Object Subtype", 'Test');
        if AllObjWithCaption.FindSet() then
            repeat
                CALTestEnabledCodeunit."No." := 0;
                CALTestEnabledCodeunit."Test Codeunit ID" := AllObjWithCaption."Object ID";
                CALTestEnabledCodeunit.Insert();
            until AllObjWithCaption.Next() = 0;
    end;

    [Scope('OnPrem')]
    procedure ExportTCM(FileName: Text)
    var
        CALTestCoverageMap: XMLport "CAL Test Coverage Map";
        OutStream: OutStream;
        File: File;
    begin
        if FileName = '' then
            exit;

        if Exists(FileName) then
            Erase(FileName);

        if File.Create(FileName) then begin
            File.CreateOutStream(OutStream);
            CALTestCoverageMap.SetDestination(OutStream);
            CALTestCoverageMap.ImportFile(false);
            CALTestCoverageMap.Export();
            File.Close();
        end;
    end;

    [Scope('OnPrem')]
    procedure ExportTestResults(FileName: Text; SkipPassed: Boolean; LastTestRun: Boolean)
    var
        CALExportTestResult: XMLport "CAL Export Test Result";
        OutStream: OutStream;
        File: File;
    begin
        if FileName = '' then
            exit;

        if Exists(FileName) then
            Erase(FileName);

        if File.Create(FileName) then begin
            File.CreateOutStream(OutStream);
            CALExportTestResult.SetParam(SkipPassed, LastTestRun);
            CALExportTestResult.SetDestination(OutStream);
            CALExportTestResult.ImportFile(false);
            CALExportTestResult.Export();
            File.Close();
        end;
    end;

    [Scope('OnPrem')]
    procedure ImportTestToRun(FileName: Text; Clean: Boolean)
    var
        CALTestEnabledCodeunit: Record "CAL Test Enabled Codeunit";
        CALImportEnabledCodeunit: XMLport "CAL Import Enabled Codeunit";
        InStream: InStream;
        File: File;
    begin
        if FileName = '' then
            exit;

        if not Exists(FileName) then
            exit;

        if Clean then
            CALTestEnabledCodeunit.DeleteAll();

        File.WriteMode(false);
        File.Open(FileName);
        File.CreateInStream(InStream);
        CALImportEnabledCodeunit.SetSource(InStream);
        CALImportEnabledCodeunit.ImportFile(true);
        CALImportEnabledCodeunit.Import();
        File.Close();
    end;
}


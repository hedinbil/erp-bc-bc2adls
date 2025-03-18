page 82564 "Deleted Tables Not To Sync"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Deleted Tables Not to Sync";
    Permissions =
        tabledata "ADLSE Table" = R,
        tabledata "Deleted Tables Not to Sync" = RIMD,
        tabledata "Table Metadata" = R;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(TableId; Rec.TableId)
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TableMetadata: Record "Table Metadata";
                    begin
                        GetTableId(TableMetadata);
                        if Page.RunModal(Page::"Available Table Selection List", TableMetadata) = Action::LookupOK then
                            Rec.TableId := TableMetadata.ID;
                    end;
                }
                field("Table Caption"; Rec."Table Caption") { }
            }
        }
    }
    local procedure GetTableId(var TableMetadata: Record "Table Metadata")
    var
        ADLSETable: Record "ADLSE Table";
        TableFilterTxt: Text;
    begin
        ADLSETable.Reset();
        if ADLSETable.FindSet() then
            repeat
                if TableFilterTxt = '' then
                    TableFilterTxt := Format(ADLSETable."Table ID")
                else
                    TableFilterTxt += '|' + Format(ADLSETable."Table ID");
            until ADLSETable.Next() = 0;
        TableMetadata.SetFilter(TableMetadata.ID, TableFilterTxt);
    end;
}
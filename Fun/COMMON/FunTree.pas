unit FunTree;

interface

uses Winapi.Windows {TreeView_SetItem}, Winapi.CommCtrl,
     System.SysUtils, System.Classes, System.IniFiles,
     Vcl.Dialogs, Vcl.ComCtrls,
     FunType;

{������������� �������� ������ � ��������� ������}
procedure SetNodeState(const PNode: PTreeNode; const Flags: Integer);
{������ TREE CHECKED}
procedure SetTreeChecked(const PTree: PTreeView);
{��������� NODE_CHECK}
function GetTreeNodeCheck(Node: TTreeNode): Boolean;
{������������� NODE_CHECK}
procedure SetTreeNodeCheck(Node: TTreeNode; const Val: Boolean);
{������������� ������ NODE}
procedure SetTreeNodeHeight(Node: TTreeNode; const Step: Byte);
{������������� ������ ���� NODE}
procedure SetTreeNodeHeightAll(Tree: TTreeView; const Height: Byte);
{������������� HINT}
procedure SetTreeHint(Tree: TTreeView; const Val: Boolean);
{��������� ���� ����}
function  GetNodePath(const PNode: PTreeNode): String;
{���� ������ ���� � ��������� SPath}
function  FindNodePath(const PTree: PTreeView; const SPath: String; const IsAll: Boolean): TTreeNode;
{���� ������ ���� � ���������� SText � PData}
function  FindNode(const PTree: PTreeView; const SText: String; const PData: Pointer): TTreeNode;
{���� ������ ���� � ���������� SText � ILevel}
function  FindNodeLevel(const PTree: PTreeView; const SText: String; const ILevel: Integer): TTreeNode;
{���� ������ ���� � ��������� SText}
function  FindNodeText(const PTree: PTreeView; const SText: String): TTreeNode;
{���� ������ ���� � ��������� PData}
function  FindNodeData(const PTree: PTreeView; const PData: Pointer): TTreeNode;
{����� ���������� ���� �� ����� LTEXT}
function  FindNextNodeLText(const PTree: PTreeView; const NodeStart: TTreeNode; const PLText: PStringList): TTreeNode;
{������� ��� ����, �� ������� ����� � Data=0}
procedure DelEmptyNode(const PTree: PTreeView);
{��������� ��������� � Tree}
procedure SaveTreeSelect(const PTree: PTreeView; const Section, Key: String);
//procedure SaveTreeSelectBD(const PTable: PADOTable; const PTree: PTreeView; const Key: String);
{��������������� ��������� � Tree}
procedure LoadTreeSelect(const PTree: PTreeView; const Section, Key: String);
//procedure LoadTreeSelectBD(const PTable: PADOTable; const PTree: PTreeView; const Key: String);
{������������� Tree � ����������� �� ���������}
procedure AutoScrollTree(const PTree: PTreeView);

implementation

uses FunConst, FunText, FunBD;


{==============================================================================}
{=====         ������������� �������� ������ � ��������� ������       =========}
{=====   TVIS_BOLD - ����� ��p��� or TVIS_CUT-������� ������ 0-�����  =========}
{==============================================================================}
procedure SetNodeState(const PNode: PTreeNode; const Flags: Integer);
var tvi: TTVItem;
begin
    If PNode=nil then Exit;
    If not Assigned(PNode^) then Exit;
    FillChar(tvi, Sizeof(tvi), 0);
    tvi.hItem := PNode^.ItemID;
    tvi.mask := TVIF_STATE;
    tvi.stateMask := TVIS_BOLD or TVIS_CUT;
    tvi.state := Flags;
    TreeView_SetItem(PNode^.Handle, tvi);
end;


{==============================================================================}
{=========================   ������ TREE CHECKED   ============================}
{==============================================================================}
procedure SetTreeChecked(const PTree: PTreeView);
var Style: DWORD;
begin
    Style := GetWindowLong(PTree^.Handle, GWL_STYLE);
    Style := Style or TVS_CHECKBOXES;
    SetWindowlong(PTree^.Handle, GWL_STYLE, Style);
end;


{==============================================================================}
{========================   ��������� NODE_CHECK   ============================}
{==============================================================================}
function GetTreeNodeCheck(Node: TTreeNode): Boolean;
const TVIS_CHECKED = $2000;
var Item: TTVItem;
begin
    Item.mask  := TVIF_STATE;
    Item.hItem := Node.ItemId;
    If TreeView_GetItem(Node.TreeView.Handle, Item) then Result := ((Item.State and TVIS_CHECKED) = TVIS_CHECKED)
                                                    else Result := false;
end;


{==============================================================================}
{======================   ������������� NODE_CHECK   ==========================}
{==============================================================================}
procedure SetTreeNodeCheck(Node: TTreeNode; const Val: Boolean);
const TVIS_CHECKED = $2000;
var Item: TTVItem;
begin
    FillChar(Item, SizeOf(TTVItem), 0);
    Item.mask  := TVIF_STATE;
    Item.stateMask := TVIS_STATEIMAGEMASK;
    Item.hItem := Node.ItemId;
    If Val then Item.state := TVIS_CHECKED
           else Item.state := TVIS_CHECKED Shr 1;
    TreeView_SetItem(Node.TreeView.Handle, Item);
end;


{==============================================================================}
{=====================   ������������� ������ NODE   ==========================}
{==============================================================================}
procedure SetTreeNodeHeight(Node: TTreeNode; const Step: Byte);
var Item: TTVItemEx;
begin
    Item.mask      := TVIF_INTEGRAL or TVIF_HANDLE;
    Item.hItem     := Node.ItemId;
    Item.iIntegral := Step;

    SendMessage(Node.TreeView.Handle, TVM_SETITEM, 0, LPARAM(@Item));
    Node.TreeView.Invalidate;
end;


{==============================================================================}
{====================   ������������� ������ ���� NODE   ======================}
{==============================================================================}
procedure SetTreeNodeHeightAll(Tree: TTreeView; const Height: Byte);
begin
    TreeView_SetItemHeight(Tree.Handle, Height);
end;



{==============================================================================}
{=========================   ������������� HINT   =============================}
{==============================================================================}
procedure SetTreeHint(Tree: TTreeView; const Val: Boolean);
begin
    If Val then SetWindowLong(Tree.Handle, GWL_STYLE, GetWindowLong(Tree.Handle, GWL_STYLE) xor TVS_NOTOOLTIPS)
           else SetWindowLong(Tree.Handle, GWL_STYLE, GetWindowLong(Tree.Handle, GWL_STYLE) or  TVS_NOTOOLTIPS);
end;


{==============================================================================}
{=========================   ��������� ���� ����   ============================}
{==============================================================================}
function GetNodePath(const PNode: PTreeNode): String;
var N: TTreeNode;
begin
    {�������������}
    Result:='';
    N:=PNode^;

    {������������� ����}
    While N<>nil do begin
       Result := N.Text+'\'+Result;
       N      := N.Parent;
    end;
end;


{==============================================================================}
{=================     ���� ������ ���� � ��������� SPATH     =================}
{==============================================================================}
function FindNodePath(const PTree: PTreeView; const SPath: String; const IsAll: Boolean): TTreeNode;
var N, Result0 : TTreeNode;
    S          : String;
    I, ILength : Integer;
begin
    {�������������}
    Result  := nil;
    Result0 := nil;
    ILength := 0;
    If PTree=nil then Exit;

    {������������� ����}
    N:=PTree^.Items.GetFirstNode;
    While N<>nil do begin
        S:=GetNodePath(@N);

        {������ ����������}
        If CmpStr(S, SPath) then begin
           Result:=N;
           Break;
        end;

        {��������� ����������}
        If Not IsAll then begin
           I:=CmpStrFirst(S, SPath);
           If I>ILength then begin ILength:=I; Result0:=N; end;
        end;

        {��������� ����}
        N:=N.GetNext;
    end;

    {��� ��������� ����������}
    If (Result=nil) and (not IsAll) and (Result0<>nil) then Result:=Result0;
end;


{==============================================================================}
{=============    ���� ������ ���� � ���������� STEXT � PDATA    ==============}
{==============================================================================}
function FindNode(const PTree: PTreeView; const SText: String; const PData: Pointer): TTreeNode;
var N: TTreeNode;
begin
    {�������������}
    Result:=nil;
    If PTree=nil then Exit;

    N:=PTree^.Items.GetFirstNode;
    While N<>nil do begin
        If (N.Data=PData) and CmpStr(N.Text, SText) then begin
           Result:=N;
           Break;
        end;
        N:=N.GetNext;
    end;
end;


{==============================================================================}
{============    ���� ������ ���� � ���������� STEXT � ILEVEL    ==============}
{==============================================================================}
function  FindNodeLevel(const PTree: PTreeView; const SText: String; const ILevel: Integer): TTreeNode;
var N: TTreeNode;
begin
    {�������������}
    Result:=nil;
    If PTree=nil then Exit;

    N:=PTree^.Items.GetFirstNode;
    While N<>nil do begin
        If (N.Level=ILevel) and CmpStr(N.Text, SText) then begin
           Result:=N;
           Break;
        end;
        N:=N.GetNext;
    end;
end;


{==============================================================================}
{=================     ���� ������ ���� � ��������� STEXT     =================}
{==============================================================================}
function FindNodeText(const PTree: PTreeView; const SText: String): TTreeNode;
var N: TTreeNode;
begin
    {�������������}
    Result:=nil;
    If PTree=nil then Exit;

    N:=PTree^.Items.GetFirstNode;
    While N<>nil do begin
        If CmpStr(N.Text, SText) then begin
           Result:=N;
           Break;
        end;
        N:=N.GetNext;
    end;
end;


{==============================================================================}
{=================     ���� ������ ���� � ��������� PDATA     =================}
{==============================================================================}
function FindNodeData(const PTree: PTreeView; const PData: Pointer): TTreeNode;
var N: TTreeNode;
begin
    {�������������}
    Result:=nil;
    If PTree=nil then Exit;

    N:=PTree^.Items.GetFirstNode;
    While N<>nil do begin
        If N.Data=PData then begin
           Result:=N;
           Break;
        end;
        N:=N.GetNext;
    end;
end;


{==============================================================================}
{===============     ����� ���������� ���� �� ����� LTEXT     =================}
{==============================================================================}
function FindNextNodeLText(const PTree: PTreeView; const NodeStart: TTreeNode; const PLText: PStringList): TTreeNode;
var N             : TTreeNode;
    SPath         : String;
    INodeStart, I : Integer;
    IsFind        : Boolean;
begin
    {�������������}
    Result:=nil;
    If (PTree = nil) or (PLText = nil) then Exit;
    If PTree^.Items.Count = 0 then Exit;
    If PLText^.Count = 0      then Exit;

    {��������� ����}
    If NodeStart <> nil then N := NodeStart.GetNext
                        else N := PTree^.Items.GetFirstNode;
    If N = nil then N := PTree^.Items.GetFirstNode;
    If N = nil then Exit;
    INodeStart := N.AbsoluteIndex;

    repeat
       {���� ������}
       IsFind := true;
       SPath  := GetNodePath(@N);
       For I := 0 to PLText^.Count-1 do begin
          If FindStr(PLText^[I], SPath)<=0 then begin
             IsFind := false;
             Break;
          end;
       end;

       {���� ������}
       If IsFind then begin
          Result := N;
          Break;
       end;

       {��������� ����}
       N := N.GetNext;
       If N = nil then N := PTree^.Items.GetFirstNode;
    until Integer(N.AbsoluteIndex) = INodeStart;
end;


{==============================================================================}
{===========     ������� ��� ����, �� ������ ����� � DATA=ID_DIR    ===========}
{==============================================================================}
procedure DelEmptyNode(const PTree: PTreeView);

   function NDel: Boolean;
   var N: TTreeNode;
   begin
       Result := false;
       N := PTree^.Items.GetFirstNode;
       While N <> nil do begin
          If (N.Data = Pointer(ID_DIR)) and (N.Count = 0) then begin
             N.Delete;
             Result := true;
             Break;
          end;
          N:=N.GetNext;
       end;
   end;
begin
    {��������� ���� ���� ��� �������, ��� ���� ������ �������� �������}
    While NDel do;
end;


{==============================================================================}
{======================   ��������� ��������� � TREE    =======================}
{==============================================================================}
procedure SaveTreeSelect(const PTree: PTreeView; const Section, Key: String);
var F : TIniFile;
    N : TTreeNode;
begin
    N := PTree^.Selected;
    F := TIniFile.Create(PATH_WORK_INI);
    try     F.WriteString(Section, Key, GetNodePath(@N));
    finally F.Free; end;
end;

(*
procedure SaveTreeSelectBD(const PTable: PADOTable; const PTree: PTreeView; const Key: String);
var N : TTreeNode;
begin
    N := PTree^.Selected;
    TableWriteVar(PTable, Key, GetNodePath(@N));
end;
*)


{==============================================================================}
{==================   ��������������� ��������� � TREE    =====================}
{==============================================================================}
procedure LoadTreeSelect(const PTree: PTreeView; const Section, Key: String);
var Event : TTVChangedEvent;
    F     : TIniFile;
    N     : TTreeNode;
    SPath : String;
begin
    If PTree=nil then Exit;

    {������ ���� ���������}
    F := TIniFile.Create(PATH_WORK_INI);
    try     SPath := F.ReadString(Section, Key, '');
    finally F.Free; end;
    If SPath = '' then Exit;

    {���� ���� ���������}
    N := FindNodePath(PTree, SPath, false);
    If N=nil then begin
       If PTree^.Items.Count=0 then Exit;
       N := PTree^.Items[0];
    end;

    {������������� ���������}
    Event           := PTree^.OnChange;
    PTree^.OnChange := nil;
    PTree.Selected  := N;
    PTree^.OnChange := Event;
end;


(*
procedure LoadTreeSelectBD(const PTable: PADOTable; const PTree: PTreeView; const Key: String);
var Event : TTVChangedEvent;
    N     : TTreeNode;
    SPath : String;
begin
    If PTree=nil then Exit;

    {������ ���� ���������}
    SPath := TableReadVar(PTable, Key, '');
    If SPath = '' then Exit;

    {���� ���� ���������}
    N := FindNodePath(PTree, SPath, false);
    If N=nil then begin
       If PTree^.Items.Count=0 then Exit;
       N := PTree^.Items[0];
    end;

    {������������� ���������}
    Event           := PTree^.OnChange;
    PTree^.OnChange := nil;
    PTree.Selected  := N;
    PTree^.OnChange := Event;
end;
*)


{==============================================================================}
{===========   ������������� TREE � ����������� �� ���������    ===============}
{==============================================================================}
procedure AutoScrollTree(const PTree: PTreeView);
var N1, N2 : TTreeNode;
    I      : Integer;
begin
    If PTree = nil then Exit;
    If Not Assigned(PTree^.Selected) then Exit;
    N1 := PTree^.Selected;
    N2 := N1;
    For I := 1 to (PTree^.Height Div 30) do begin
       If N1 <> nil then begin
          N2 := N1;
          N1 := N1.GetPrevVisible;
       end;
    end;   
    PTree^.TopItem := N2;
end;

end.


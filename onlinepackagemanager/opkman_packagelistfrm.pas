unit opkman_packagelistfrm;

{$mode objfpc}{$H+}
{
 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.        *
 *                                                                         *
 ***************************************************************************

 Author: Balázs Székely
}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, opkman_VirtualTrees;

type

  { TPackageListFrm }

  TPackageListFrm = class(TForm)
    bOk: TButton;
    bYes: TButton;
    bNo: TButton;
    imTree: TImageList;
    lbMessage: TLabel;
    pnUpDown: TPanel;
    pnMessage: TPanel;
    pnButtons: TPanel;
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure lbMessageResize(Sender: TObject);
  private
    FVST: TVirtualStringTree;
    FModRes: TModalResult;
    function GetCount: Integer;
    procedure SetupControls(const ATyp: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; {%H-}TextType: TVSTTextType; var CellText: String);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      {%H-}Kind: TVTImageKind; Column: TColumnIndex; var {%H-}Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
  public
    procedure PopulateList(const ATyp: Integer; const AExtra: String = '');
    property Count: Integer read GetCount;
  end;

var
  PackageListFrm: TPackageListFrm;

implementation
uses opkman_const, opkman_serializablepackages;

{$R *.lfm}

{ TPackageListFrm }

type
  PData = ^TData;
  TData = record
    FName: string[100];
    FImageIndex: Integer;
  end;

procedure TPackageListFrm.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    FModRes := mrYes;
    Close;
  end
  else if Key = #27 then
  begin
    FModRes := mrNo;
    Close;
  end;
end;

procedure TPackageListFrm.lbMessageResize(Sender: TObject);
begin
  pnMessage.Height := lbMessage.Top + lbMessage.Height + 5;
end;

function TPackageListFrm.GetCount: Integer;
begin
  Result := FVST.RootNodeCount;
end;

procedure TPackageListFrm.SetupControls(const ATyp: Integer);
begin
  FModRes := mrNone;
  case ATyp of
    0: Caption := rsPackageListFrmCaption0;
    1: Caption := rsPackageListFrmCaption1;
    2: Caption := rsPackageListFrmCaption2;
  end;
  bYes.Caption := rsPackageListFrmbYes;
  bNo.Caption := rsPackageListFrmbNo;
  bOk.Caption := rsPackageListFrmbOk;
  bYes.Top := (pnButtons.Height - bYes.Height) div 2;
  bNo.Top := (pnButtons.Height - bNo.Height) div 2;
  bOk.Top := (pnButtons.Height - bOk.Height) div 2;
  pnMessage.Height := lbMessage.Top + lbMessage.Height + 5;
end;

procedure TPackageListFrm.PopulateList(const ATyp: Integer; const AExtra: String);
var
  I, J: Integer;
  Node: PVirtualNode;
  Data: PData;
  PackageFile: TPackageFile;
  ChkCnt, InvCnt: Integer;
begin
  SetupControls(ATyp);
  ChkCnt := 0;
  InvCnt := 0;
  for I := 0 to SerializablePackages.Count - 1 do
  begin
    if ATyp = 0 then
    begin
      for J := 0 to SerializablePackages.Items[I].PackageFiles.Count - 1  do
      begin
        PackageFile := TPackageFile(SerializablePackages.Items[I].PackageFiles.Items[J]);
        if (PackageFile.Checked) and (psInstalled in PackageFile.PackageStates) then
        begin
          Node := FVST.AddChild(nil);
          Data := FVST.GetNodeData(Node);
          Data^.FName := PackageFile.Name + '(' + PackageFile.VersionAsString + ')';
          Data^.FImageIndex := 1;
        end;
      end;
    end
    else if ATyp = 1 then
    begin
      if (SerializablePackages.Items[I].Checked) and (FileExists(AExtra + SerializablePackages.Items[I].RepositoryFileName)) then
      begin
        Node := FVST.AddChild(nil);
        Data := FVST.GetNodeData(Node);
        Data^.FName := SerializablePackages.Items[I].Name;
        Data^.FImageIndex := 0;
      end;
    end
    else if ATyp = 2 then
    begin
      if (SerializablePackages.Items[I].Checked) then
      begin
        Inc(ChkCnt);
        if (Trim(SerializablePackages.Items[I].DownloadURL) = '') then
        begin
          Inc(InvCnt);
          Node := FVST.AddChild(nil);
          Data := FVST.GetNodeData(Node);
          Data^.FName := SerializablePackages.Items[I].Name;
          Data^.FImageIndex := 0;
          SerializablePackages.Items[I].ChangePackageStates(ctAdd, psError);
        end;
      end;
    end;
  end;
  if (ATyp = 2) and (ChkCnt = InvCnt) then
  begin
    bYes.Visible := False;
    bNo.Visible := False;
    bOk.Visible := True;
    lbMessage.Caption := rsMainFrmPackageUpdate1;
  end;
  FVST.SortTree(0, opkman_VirtualTrees.sdAscending);
end;

procedure TPackageListFrm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if FModRes <> mrNone then
    ModalResult := FModRes;
end;

procedure TPackageListFrm.FormCreate(Sender: TObject);
begin
  FVST := TVirtualStringTree.Create(nil);
  with FVST do
  begin
    Parent := Self;
    Align := alClient;
    Anchors := [akLeft, akTop, akRight];
    Images := imTree;
    Color := clBtnFace;
    DefaultNodeHeight := 25;
    Indent := 0;
    TabOrder := 1;
    DefaultText := '';
    Header.AutoSizeIndex := 0;
    Header.Height := 25;
    Colors.BorderColor := clBlack;
    BorderSpacing.Top := 5;
    BorderSpacing.Left := 10;
    BorderSpacing.Right := 10;
    with Header.Columns.Add do begin
      Position := 0;
      Width := 250;
      Text := 'PackageName';
    end;
    Header.Options := [hoAutoResize, hoColumnResize, hoRestrictDrag, hoShowSortGlyphs, hoAutoSpring];
    Header.SortColumn := 0;
    TabOrder := 2;
    TreeOptions.MiscOptions := [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning];
    TreeOptions.PaintOptions := [toHideFocusRect, toPopupMode, toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages];
    TreeOptions.SelectionOptions := [toFullRowSelect, toRightClickSelect];
    TreeOptions.AutoOptions := [toAutoTristateTracking];
    OnGetText := @VSTGetText;
    OnGetImageIndex := @VSTGetImageIndex;
    OnCompareNodes := @VSTCompareNodes;
    OnFreeNode := @VSTFreeNode;
  end;
  FVST.NodeDataSize := SizeOf(TData);
end;

procedure TPackageListFrm.FormDestroy(Sender: TObject);
begin
  FVST.Clear;
  FVST.Free;
end;

procedure TPackageListFrm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  Data: PData;
begin
  Data := FVST.GetNodeData(Node);
  if Column = 0 then
    CellText := Data^.FName;
end;

procedure TPackageListFrm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PData;
begin
  Data := FVST.GetNodeData(Node);
  if Column = 0 then
    ImageIndex := Data^.FImageIndex;
end;

procedure TPackageListFrm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1: PData;
  Data2: PData;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  if Column = 0 then
    Result := CompareText(Data1^.FName, Data2^.FName);
end;

procedure TPackageListFrm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PData;
begin
  Data := FVST.GetNodeData(Node);
  Finalize(Data^);
end;

end.


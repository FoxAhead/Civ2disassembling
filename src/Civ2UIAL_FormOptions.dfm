object FormOptions: TFormOptions
  Left = 605
  Top = 250
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 245
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    513
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object CheckListBox1: TCheckListBox
    Left = 4
    Top = 4
    Width = 133
    Height = 205
    OnClickCheck = CheckListBox1ClickCheck
    Flat = False
    ItemHeight = 13
    TabOrder = 0
    OnClick = CheckListBox1Click
  end
  object ButtonOK: TButton
    Left = 152
    Top = 216
    Width = 101
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 260
    Top = 216
    Width = 101
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 144
    Top = 4
    Width = 365
    Height = 205
    TabStop = False
    ReadOnly = True
    TabOrder = 3
  end
end

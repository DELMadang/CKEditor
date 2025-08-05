object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'CKEditor Test'
  ClientHeight = 607
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object EdgeBrowser1: TEdgeBrowser
    Left = 0
    Top = 29
    Width = 774
    Height = 578
    Align = alClient
    TabOrder = 0
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnCreateWebViewCompleted = EdgeBrowser1CreateWebViewCompleted
    OnWebMessageReceived = EdgeBrowser1WebMessageReceived
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 774
    Height = 29
    ButtonHeight = 23
    ButtonWidth = 94
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 1
    object tbGet: TToolButton
      Left = 0
      Top = 0
      Caption = #53581#49828#53944' '#44032#51256#50724#44592
      ImageIndex = 0
      OnClick = tbGetClick
    end
    object tbPut: TToolButton
      Left = 94
      Top = 0
      Caption = #53581#49828#53944' '#51077#47141#54616#44592
      ImageIndex = 1
      OnClick = tbPutClick
    end
    object tbClear: TToolButton
      Left = 188
      Top = 0
      Caption = #51648#50864#44592
      ImageIndex = 2
      OnClick = tbClearClick
    end
  end
end

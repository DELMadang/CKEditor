unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.WebView2,
  Winapi.ActiveX,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Edge,
  Vcl.ComCtrls,
  Vcl.ToolWin;

type
  TfrmMain = class(TForm)
    EdgeBrowser1: TEdgeBrowser;
    ToolBar1: TToolBar;
    tbGet: TToolButton;
    tbPut: TToolButton;
    tbClear: TToolButton;
    procedure EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser;
        AResult: HRESULT);
    procedure EdgeBrowser1WebMessageReceived(Sender: TCustomEdgeBrowser; Args:
        TWebMessageReceivedEventArgs);
    procedure tbClearClick(Sender: TObject);
    procedure tbGetClick(Sender: TObject);
    procedure tbPutClick(Sender: TObject);
  private
    procedure LoadEditor;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  if not EdgeBrowser1.WebViewCreated then
  begin
    EdgeBrowser1.UserDataFolder := ExtractFilePath(Application.ExeName) + 'WebView2Data';
    EdgeBrowser1.CreateWebView;
  end;
end;

procedure TfrmMain.EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  if SUCCEEDED(AResult) then
  begin
    LoadEditor();
  end;
end;

procedure TfrmMain.EdgeBrowser1WebMessageReceived(Sender: TCustomEdgeBrowser;
    Args: TWebMessageReceivedEventArgs);
var
  LBuffer: PWideChar;
begin
  if Args.ArgsInterface.Get_webMessageAsJson(LBuffer) = S_OK then
  begin
    var LJSON := TJSONObject.ParseJSONValue(string(LBuffer)) as TJSONObject;
    try
      ShowMessage(LJSON.ToString);
    finally
      LJSON.Free;
    end;
  end;
end;

procedure TfrmMain.LoadEditor;
{$REGION 'HTML'}
const
  HTML = '''
  <!DOCTYPE html>
  <html lang="ko">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CKEditor Complete Headings</title>
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
    <style>
      html, body {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
        overflow: hidden;
        font-family: Arial, sans-serif;
      }

      #editor-container {
        height: 100vh;
        width: 100vw;
        display: flex;
        flex-direction: column;
      }

      .ck.ck-editor {
        flex: 1;
        display: flex;
        flex-direction: column;
      }

      .ck.ck-editor__top {
        flex-shrink: 0;
      }

      .ck.ck-editor__main {
        flex: 1;
        display: flex;
        flex-direction: column;
        overflow: hidden;
      }

      .ck.ck-editor__editable {
        flex: 1 !important;
        min-height: auto !important;
        height: auto !important;
        overflow-y: scroll !important;
        resize: none;
      }

      /* 커스텀 헤딩 스타일 */
      .ck-content .custom-heading-large {
        font-size: 2.5em;
        font-weight: bold;
        color: #2196F3;
        margin: 20px 0;
        padding: 10px;
        border-left: 5px solid #2196F3;
        background-color: #f8f9fa;
      }

      .ck-content .custom-heading-subtitle {
        font-size: 1.2em;
        font-weight: normal;
        color: #666;
        font-style: italic;
        margin: 10px 0;
        padding: 5px 0;
        border-bottom: 1px dashed #ccc;
      }

      .ck-content .custom-heading-box {
        font-size: 1.5em;
        font-weight: bold;
        color: white;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 15px;
        border-radius: 8px;
        margin: 15px 0;
        text-align: center;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      }

      .ck-content .custom-heading-minimal {
        font-size: 1.1em;
        font-weight: 600;
        color: #333;
        margin: 8px 0;
        text-transform: uppercase;
        letter-spacing: 1px;
      }

      /* 기본 헤딩 스타일 커스터마이징 */
      .ck-content h1 {
        font-size: 2.2em;
        color: #1a1a1a;
        border-bottom: 3px solid #e74c3c;
        padding-bottom: 10px;
      }

      .ck-content h2 {
        font-size: 1.8em;
        color: #2c3e50;
        border-left: 4px solid #3498db;
        padding-left: 15px;
      }

      .ck-content h3 {
        font-size: 1.5em;
        color: #27ae60;
        background: #ecf0f1;
        padding: 8px 12px;
        border-radius: 4px;
      }

      .ck-content h4 {
        font-size: 1.3em;
        color: #8e44ad;
        border-bottom: 2px dotted #8e44ad;
      }

      .ck-content h5 {
        font-size: 1.1em;
        color: #e67e22;
        font-weight: 600;
      }

      .ck-content h6 {
        font-size: 1em;
        color: #7f8c8d;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
    </style>
  </head>
  <body>
    <div id="editor-container">
      <div id="editor">
      </div>
    </div>

    <script>
      let editorInstance;

      ClassicEditor.create(document.querySelector("#editor"), {
        language: "ko",
        toolbar: [
          "heading", "|",
          "fontSize", "fontFamily", "|",
          "bold", "italic", "underline", "strikethrough", "|",
          "fontColor", "fontBackgroundColor", "|",
          "alignment", "|",
          "numberedList", "bulletedList", "|",
          "outdent", "indent", "|",
          "link", "blockQuote", "insertTable", "|",
          "undo", "redo"
        ],

        // 모든 헤딩 옵션 설정
        heading: {
          options: [
            {
              model: "paragraph",
              title: "일반 문단",
              class: "ck-heading_paragraph"
            },
            {
              model: "heading1",
              view: "h1",
              title: "제목 1 (가장 큰 제목)",
              class: "ck-heading_heading1"
            },
            {
              model: "heading2",
              view: "h2",
              title: "제목 2 (섹션 제목)",
              class: "ck-heading_heading2"
            },
            {
              model: "heading3",
              view: "h3",
              title: "제목 3 (서브섹션)",
              class: "ck-heading_heading3"
            },
            {
              model: "heading4",
              view: "h4",
              title: "제목 4 (소제목)",
              class: "ck-heading_heading4"
            },
            {
              model: "heading5",
              view: "h5",
              title: "제목 5 (작은 제목)",
              class: "ck-heading_heading5"
            },
            {
              model: "heading6",
              view: "h6",
              title: "제목 6 (최소 제목)",
              class: "ck-heading_heading6"
            },

            // 커스텀 헤딩 옵션들
            {
              model: "headingCustomLarge",
              view: {
                name: "h2",
                classes: "custom-heading-large"
              },
              title: "대형 강조 제목",
              class: "ck-heading_custom-large"
            },
            {
              model: "headingSubtitle",
              view: {
                name: "p",
                classes: "custom-heading-subtitle"
              },
              title: "부제목 스타일",
              class: "ck-heading_subtitle"
            },
            {
              model: "headingBox",
              view: {
                name: "div",
                classes: "custom-heading-box"
              },
              title: "박스형 제목",
              class: "ck-heading_box"
            },
            {
              model: "headingMinimal",
              view: {
                name: "h4",
                classes: "custom-heading-minimal"
              },
              title: "미니멀 제목",
              class: "ck-heading_minimal"
            }
          ]
        },

        fontSize: {
          options: [9, 11, 13, "default", 17, 19, 21, 24, 28, 32]
        },

        fontFamily: {
          options: [
            "default",
            "Arial, Helvetica, sans-serif",
            "Courier New, Courier, monospace",
            "Georgia, serif",
            "Times New Roman, Times, serif",
            "Verdana, Geneva, sans-serif",
            "Malgun Gothic, 맑은 고딕, sans-serif",
            "Batang, 바탕, serif",
            "Dotum, 돋움, sans-serif"
          ]
        }
      })
      .then(editor => {
        editorInstance = editor;

        // 에디터 생성 후 추가 설정
        setTimeout(() => {
          const editableElement = editor.ui.getEditableElement();
          if (editableElement) {
            editableElement.style.overflowY = 'scroll';
          }
        }, 100);
      })
      .catch(error => {
        console.error("CKEditor 초기화 실패:", error);
      });

      // 유틸리티 함수들
      function getEditorContent() {
        if (editorInstance) {
          const text = editorInstance.getData();
          window.chrome.webview.postMessage({event: "getContent", data: text});
        }
      }

      function setEditorContent(content) {
        if (editorInstance) {
          editorInstance.setData(content);
        }
      }

      function clearEditor() {
        if (editorInstance) {
          editorInstance.setData("");
        }
      }

      // 특정 헤딩 적용 함수
      function applyHeading(headingType) {
        if (editorInstance) {
          editorInstance.execute('heading', { value: headingType });
        }
      }
    </script>
  </body>
  </html>
  ''';
{$ENDREGION}
begin
  EdgeBrowser1.NavigateToString(HTML);
end;

procedure TfrmMain.tbGetClick(Sender: TObject);
begin
  EdgeBrowser1.ExecuteScript('getEditorContent()');
end;

procedure TfrmMain.tbPutClick(Sender: TObject);
const
  TEXT = '''
  <h1>델파이에서 설정한 제목</h1><p>이 내용은
  <strong>델파이</strong>에서 설정되었습니다.</p>
  ''';
begin
  var LContent := StringReplace(TEXT, '"', '\"', [rfReplaceAll]);
  LContent := StringReplace(LContent, #13#10, '\n', [rfReplaceAll]);

  var LScript := Format('setEditorContent("%s")', [LContent]);
  EdgeBrowser1.ExecuteScript(LScript);
end;

procedure TfrmMain.tbClearClick(Sender: TObject);
begin
  EdgeBrowser1.ExecuteScript('clearEditor()');
end;

end.

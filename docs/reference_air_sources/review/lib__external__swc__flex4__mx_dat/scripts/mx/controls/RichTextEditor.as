package mx.controls
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.ControlBar;
   import mx.containers.HBox;
   import mx.containers.Panel;
   import mx.controls.richTextEditorClasses.ToolBar;
   import mx.controls.textClasses.TextRange;
   import mx.core.IFlexModuleFactory;
   import mx.core.IUITextField;
   import mx.core.UIComponentDescriptor;
   import mx.core.UITextFormat;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   [Exclude(name="underlineButton",kind="property")]
   [Exclude(name="toolBar2",kind="property")]
   [Exclude(name="toolBar",kind="property")]
   [Exclude(name="linkTextInput",kind="property")]
   [Exclude(name="layout",kind="property")]
   [Exclude(name="label",kind="property")]
   [Exclude(name="italicButton",kind="property")]
   [Exclude(name="icon",kind="property")]
   [Exclude(name="fontSizeCombo",kind="property")]
   [Exclude(name="fontSizeArray",kind="property")]
   [Exclude(name="fontFamilyCombo",kind="property")]
   [Exclude(name="fontFamilyArray",kind="property")]
   [Exclude(name="defaultButton",kind="property")]
   [Exclude(name="colorPicker",kind="property")]
   [Exclude(name="bulletButton",kind="property")]
   [Exclude(name="boldButton",kind="property")]
   [Exclude(name="alignButtons",kind="property")]
   [IconFile("RichTextEditor.png")]
   [Style(name="textAreaStyleName",type="String",inherit="no")]
   [DefaultTriggerEvent("change")]
   [Event(name="change",type="flash.events.Event")]
   public class RichTextEditor extends Panel implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _RichTextEditor_VRule1:VRule;
      
      public var _RichTextEditor_VRule2:VRule;
      
      private var _1462779716alignButtons:ToggleButtonBar;
      
      private var _1040280041boldButton:Button;
      
      private var _97660628bulletButton:Button;
      
      private var _885706193colorPicker:ColorPicker;
      
      private var _610088570fontFamilyArray:Array;
      
      private var _608335685fontFamilyCombo:ComboBox;
      
      private var _1657931959fontSizeArray:Array;
      
      private var _1656179074fontSizeCombo:ComboBox;
      
      private var _1138485634italicButton:Button;
      
      private var _343678915linkTextInput:TextInput;
      
      private var _1004197030textArea:TextArea;
      
      private var _984131529toolBar2:HBox;
      
      private var _1140094085toolbar:ToolBar;
      
      private var _2023461150underlineButton:Button;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public var fontFamilyToolTip:String = "Font Family";
      
      public var fontSizeToolTip:String = "Font Size";
      
      public var boldToolTip:String = "Bold";
      
      public var italicToolTip:String = "Italic";
      
      public var underlineToolTip:String = "Underline";
      
      public var colorPickerToolTip:String = "Color";
      
      public var alignToolTip:String = "Align";
      
      public var bulletToolTip:String = "Bullet";
      
      public var linkToolTip:String = "Link";
      
      private var linkTextCommitted:Boolean = false;
      
      private var showControlBarChanged:Boolean = false;
      
      private var showToolTipsChanged:Boolean = false;
      
      private var textChanged:Boolean = false;
      
      private var htmlTextChanged:Boolean = false;
      
      private var previousTextFormat:TextFormat = null;
      
      private var textFormatChanged:Boolean = false;
      
      private var lastCaretIndex:int = -1;
      
      private var invalidateToolBarFlag:Boolean = false;
      
      private var firstTime:Boolean = true;
      
      private var _defaultLinkProtocol:String = "http://";
      
      private var _showControlBar:Boolean = true;
      
      private var _showToolTips:Boolean = false;
      
      private var _text:String = "";
      
      private var _htmlText:String = "";
      
      private var _embed_mxml_assets_icon_style_italic_png_1606210442:Class;
      
      private var _embed_mxml_assets_icon_align_left_png_848182540:Class;
      
      private var _embed_mxml_assets_icon_align_center_png_627254320:Class;
      
      private var _embed_mxml_assets_icon_bullet_png_1161633650:Class;
      
      private var _embed_mxml_assets_icon_align_right_png_240974432:Class;
      
      private var _embed_mxml_assets_icon_style_bold_png_1028202784:Class;
      
      private var _embed_mxml_assets_icon_align_justify_png_627315648:Class;
      
      private var _embed_mxml_assets_icon_style_underline_png_1723156464:Class;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      public function RichTextEditor()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Panel,
            "propertiesFactory":function():Object
            {
               return {
                  "width":325,
                  "height":300,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":TextArea,
                     "id":"textArea",
                     "events":{
                        "change":"__textArea_change",
                        "valueCommit":"__textArea_valueCommit",
                        "keyUp":"__textArea_keyUp",
                        "keyDown":"__textArea_keyDown",
                        "mouseDown":"__textArea_mouseDown"
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentHeight":100,
                           "percentWidth":100,
                           "minHeight":0,
                           "minWidth":0
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":ControlBar,
                     "propertiesFactory":function():Object
                     {
                        return {"childDescriptors":[new UIComponentDescriptor({
                           "type":ToolBar,
                           "id":"toolbar",
                           "stylesFactory":function():void
                           {
                              this.horizontalGap = 7;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":ComboBox,
                                    "id":"fontFamilyCombo",
                                    "events":{
                                       "creationComplete":"__fontFamilyCombo_creationComplete",
                                       "close":"__fontFamilyCombo_close",
                                       "enter":"__fontFamilyCombo_enter"
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"editable":true};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":ComboBox,
                                    "id":"fontSizeCombo",
                                    "events":{
                                       "close":"__fontSizeCombo_close",
                                       "enter":"__fontSizeCombo_enter"
                                    },
                                    "stylesFactory":function():void
                                    {
                                       this.paddingLeft = 2;
                                       this.paddingRight = 2;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"editable":true};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":HBox,
                                    "id":"toolBar2",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalGap = 0;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"childDescriptors":[new UIComponentDescriptor({
                                          "type":Button,
                                          "id":"boldButton",
                                          "events":{"click":"__boldButton_click"},
                                          "stylesFactory":function():void
                                          {
                                             this.icon = _embed_mxml_assets_icon_style_bold_png_1028202784;
                                          },
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "width":20,
                                                "toggle":true
                                             };
                                          }
                                       }),new UIComponentDescriptor({
                                          "type":Button,
                                          "id":"italicButton",
                                          "events":{"click":"__italicButton_click"},
                                          "stylesFactory":function():void
                                          {
                                             this.icon = _embed_mxml_assets_icon_style_italic_png_1606210442;
                                          },
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "width":20,
                                                "toggle":true
                                             };
                                          }
                                       }),new UIComponentDescriptor({
                                          "type":Button,
                                          "id":"underlineButton",
                                          "events":{"click":"__underlineButton_click"},
                                          "stylesFactory":function():void
                                          {
                                             this.icon = _embed_mxml_assets_icon_style_underline_png_1723156464;
                                          },
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "width":20,
                                                "toggle":true
                                             };
                                          }
                                       })]};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":ColorPicker,
                                    "id":"colorPicker",
                                    "events":{"close":"__colorPicker_close"},
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":22,
                                          "height":22
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VRule,
                                    "id":"_RichTextEditor_VRule1"
                                 }),new UIComponentDescriptor({
                                    "type":ToggleButtonBar,
                                    "id":"alignButtons",
                                    "events":{"itemClick":"__alignButtons_itemClick"},
                                    "stylesFactory":function():void
                                    {
                                       this.buttonWidth = 20;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"dataProvider":[{
                                          "icon":_embed_mxml_assets_icon_align_left_png_848182540,
                                          "action":"left"
                                       },{
                                          "icon":_embed_mxml_assets_icon_align_center_png_627254320,
                                          "action":"center"
                                       },{
                                          "icon":_embed_mxml_assets_icon_align_right_png_240974432,
                                          "action":"right"
                                       },{
                                          "icon":_embed_mxml_assets_icon_align_justify_png_627315648,
                                          "action":"justify"
                                       }]};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Button,
                                    "id":"bulletButton",
                                    "events":{"click":"__bulletButton_click"},
                                    "stylesFactory":function():void
                                    {
                                       this.icon = _embed_mxml_assets_icon_bullet_png_1161633650;
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "width":20,
                                          "toggle":true
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VRule,
                                    "id":"_RichTextEditor_VRule2"
                                 }),new UIComponentDescriptor({
                                    "type":TextInput,
                                    "id":"linkTextInput",
                                    "events":{
                                       "focusOut":"__linkTextInput_focusOut",
                                       "enter":"__linkTextInput_enter"
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {"width":140};
                                    }
                                 })]
                              };
                           }
                        })]};
                     }
                  })]
               };
            }
         });
         this._embed_mxml_assets_icon_style_italic_png_1606210442 = RichTextEditor__embed_mxml_assets_icon_style_italic_png_1606210442;
         this._embed_mxml_assets_icon_align_left_png_848182540 = RichTextEditor__embed_mxml_assets_icon_align_left_png_848182540;
         this._embed_mxml_assets_icon_align_center_png_627254320 = RichTextEditor__embed_mxml_assets_icon_align_center_png_627254320;
         this._embed_mxml_assets_icon_bullet_png_1161633650 = RichTextEditor__embed_mxml_assets_icon_bullet_png_1161633650;
         this._embed_mxml_assets_icon_align_right_png_240974432 = RichTextEditor__embed_mxml_assets_icon_align_right_png_240974432;
         this._embed_mxml_assets_icon_style_bold_png_1028202784 = RichTextEditor__embed_mxml_assets_icon_style_bold_png_1028202784;
         this._embed_mxml_assets_icon_align_justify_png_627315648 = RichTextEditor__embed_mxml_assets_icon_align_justify_png_627315648;
         this._embed_mxml_assets_icon_style_underline_png_1723156464 = RichTextEditor__embed_mxml_assets_icon_style_underline_png_1723156464;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._RichTextEditor_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_mx_controls_RichTextEditorWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return RichTextEditor[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minWidth = 220;
         this.minHeight = 200;
         this.width = 325;
         this.height = 300;
         this._RichTextEditor_Array1_i();
         this._RichTextEditor_Array2_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RichTextEditor._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      [Inspectable(defaultValue="http://")]
      public function get defaultLinkProtocol() : String
      {
         return this._defaultLinkProtocol;
      }
      
      public function set defaultLinkProtocol(value:String) : void
      {
         this._defaultLinkProtocol = value;
         if(Boolean(this.linkTextInput))
         {
            this.linkTextInput.text = this._defaultLinkProtocol;
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showControlBar() : Boolean
      {
         return this._showControlBar;
      }
      
      public function set showControlBar(value:Boolean) : void
      {
         this._showControlBar = value;
         this.showControlBarChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="false")]
      public function get showToolTips() : Boolean
      {
         return this._showToolTips;
      }
      
      public function set showToolTips(value:Boolean) : void
      {
         this._showToolTips = value;
         this.showToolTipsChanged = true;
         invalidateProperties();
      }
      
      public function get selection() : TextRange
      {
         return new TextRange(this,true);
      }
      
      [Inspectable(category="General")]
      [NonCommittingChangeEvent("change")]
      [CollapseWhiteSpace]
      [Bindable("valueCommit")]
      public function get text() : String
      {
         return Boolean(this.textArea) ? this.textArea.text : this._text;
      }
      
      public function set text(value:String) : void
      {
         this._text = value;
         this.textChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General")]
      [NonCommittingChangeEvent("change")]
      [CollapseWhiteSpace]
      [Bindable("valueCommit")]
      public function get htmlText() : String
      {
         return Boolean(this.textArea) ? this.textArea.htmlText : this._htmlText;
      }
      
      public function set htmlText(value:String) : void
      {
         this._htmlText = value;
         this.htmlTextChanged = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var textAreaStyleName:String = null;
         var tf:UITextFormat = null;
         super.commitProperties();
         if(this.firstTime)
         {
            this.firstTime = false;
            textAreaStyleName = getStyle("textAreaStyleName");
            if(Boolean(textAreaStyleName))
            {
               this.textArea.styleName = textAreaStyleName;
            }
            this.textArea.getTextField().alwaysShowSelection = true;
         }
         if(this.showControlBarChanged)
         {
            if(this._showControlBar)
            {
               controlBar.height = NaN;
               controlBar.visible = true;
            }
            else
            {
               controlBar.height = 0;
               controlBar.visible = false;
            }
            this.showControlBarChanged = false;
         }
         if(this.showToolTipsChanged)
         {
            if(this._showToolTips)
            {
               this.fontFamilyCombo.toolTip = this.fontFamilyToolTip;
               this.fontSizeCombo.toolTip = this.fontSizeToolTip;
               this.boldButton.toolTip = this.boldToolTip;
               this.italicButton.toolTip = this.italicToolTip;
               this.underlineButton.toolTip = this.underlineToolTip;
               this.colorPicker.toolTip = this.colorPickerToolTip;
               this.alignButtons.toolTip = this.alignToolTip;
               this.bulletButton.toolTip = this.bulletToolTip;
               this.linkTextInput.toolTip = this.linkToolTip;
            }
            else
            {
               this.fontFamilyCombo.toolTip = "";
               this.fontSizeCombo.toolTip = "";
               this.boldButton.toolTip = "";
               this.italicButton.toolTip = "";
               this.underlineButton.toolTip = "";
               this.colorPicker.toolTip = "";
               this.alignButtons.toolTip = "";
               this.bulletButton.toolTip = "";
               this.linkTextInput.toolTip = "";
            }
            this.showToolTipsChanged = false;
         }
         if(this.textChanged || this.htmlTextChanged)
         {
            tf = IUITextField(this.textArea.getTextField()).getUITextFormat();
            tf.bullet = false;
            this.textArea.getTextField().defaultTextFormat = tf;
            if(this.textChanged)
            {
               this.textArea.text = this._text;
               this.textChanged = false;
            }
            else
            {
               this.textArea.htmlText = this._htmlText;
               this.htmlTextChanged = false;
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = 220;
         measuredWidth = 320;
         measuredMinHeight = 200;
         measuredHeight = 300;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var textAreaStyleName:String = null;
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "textAreaStyleName")
         {
            if(Boolean(this.textArea))
            {
               textAreaStyleName = getStyle("textAreaStyleName");
               this.textArea.styleName = textAreaStyleName;
            }
         }
         if(!this.invalidateToolBarFlag)
         {
            this.invalidateToolBarFlag = true;
            callLater(this.getTextStyles);
         }
      }
      
      private function setTextStyles(type:String, value:Object = null) : void
      {
         var tf:TextFormat = null;
         var fontSize:uint = 0;
         var beginIndex:int = int(this.textArea.getTextField().selectionBeginIndex);
         var endIndex:int = int(this.textArea.getTextField().selectionEndIndex);
         if(beginIndex == endIndex)
         {
            tf = this.previousTextFormat;
         }
         else
         {
            tf = new TextFormat();
         }
         if(type == "bold" || type == "italic" || type == "underline")
         {
            tf[type] = value;
         }
         else if(type == "align" || type == "bullet")
         {
            if(beginIndex == endIndex)
            {
               tf = new TextFormat();
            }
            beginIndex = this.textArea.getTextField().getFirstCharInParagraph(beginIndex) - 1;
            beginIndex = Math.max(0,beginIndex);
            endIndex = this.textArea.getTextField().getFirstCharInParagraph(endIndex) + this.textArea.getTextField().getParagraphLength(endIndex) - 1;
            tf[type] = value;
            this.previousTextFormat[type] = value;
            if(!endIndex)
            {
               this.textArea.getTextField().defaultTextFormat = tf;
            }
         }
         else if(type == "font")
         {
            tf[type] = this.fontFamilyCombo.text;
         }
         else if(type == "size")
         {
            fontSize = uint(this.fontSizeCombo.text);
            if(fontSize > 0)
            {
               tf[type] = fontSize;
            }
         }
         else if(type == "color")
         {
            tf[type] = uint(this.colorPicker.selectedColor);
         }
         else if(type == "url")
         {
            if(value != this.defaultLinkProtocol && value != "")
            {
               tf[type] = value;
               tf["target"] = "_blank";
            }
            else if(tf[type] != "")
            {
               tf[type] = "";
               tf["target"] = "";
            }
         }
         this.textFormatChanged = true;
         if(beginIndex == endIndex)
         {
            this.previousTextFormat = tf;
         }
         else
         {
            this.textArea.getTextField().setTextFormat(tf,beginIndex,endIndex);
         }
         dispatchEvent(new Event("change"));
         var caretIndex:int = int(this.textArea.getTextField().caretIndex);
         var lineIndex:int = int(this.textArea.getTextField().getLineIndexOfChar(caretIndex));
         this.textArea.invalidateDisplayList();
         this.textArea.validateDisplayList();
         while(lineIndex >= this.textArea.getTextField().bottomScrollV)
         {
            ++this.textArea.verticalScrollPosition;
         }
         callLater(this.textArea.setFocus);
      }
      
      private function getTextStyles() : void
      {
         var tf:TextFormat = null;
         var carIndex:int = 0;
         var tfNext:TextFormat = null;
         if(!this.textArea)
         {
            return;
         }
         var beginIndex:int = int(this.textArea.getTextField().selectionBeginIndex);
         var endIndex:int = int(this.textArea.getTextField().selectionEndIndex);
         if(beginIndex == endIndex)
         {
            this.linkTextInput.enabled = false;
         }
         else
         {
            this.linkTextInput.enabled = true;
         }
         if(this.textFormatChanged)
         {
            this.previousTextFormat = null;
         }
         if(beginIndex == endIndex)
         {
            tf = this.textArea.getTextField().defaultTextFormat;
            if(tf.url != "")
            {
               carIndex = int(this.textArea.getTextField().caretIndex);
               if(carIndex < this.textArea.getTextField().length)
               {
                  tfNext = this.textArea.getTextField().getTextFormat(carIndex,carIndex + 1);
                  if(!tfNext.url || tfNext.url == "")
                  {
                     tf.url = tf.target = "";
                  }
               }
               else
               {
                  tf.url = tf.target = "";
               }
            }
         }
         else
         {
            tf = this.textArea.getTextField().getTextFormat(beginIndex,endIndex);
         }
         if(!this.previousTextFormat || this.previousTextFormat.font != tf.font)
         {
            this.setComboSelection(this.fontFamilyCombo,Boolean(tf.font) ? tf.font : "");
         }
         if(!this.previousTextFormat || this.previousTextFormat.size != tf.size)
         {
            this.setComboSelection(this.fontSizeCombo,Boolean(tf.size) ? String(tf.size) : "");
         }
         if(!this.previousTextFormat || this.previousTextFormat.color != tf.color)
         {
            this.colorPicker.selectedColor = Number(tf.color);
         }
         if(!this.previousTextFormat || this.previousTextFormat.bold != tf.bold)
         {
            this.boldButton.selected = tf.bold;
         }
         if(!this.previousTextFormat || this.previousTextFormat.italic != tf.italic)
         {
            this.italicButton.selected = tf.italic;
         }
         if(!this.previousTextFormat || this.previousTextFormat.underline != tf.underline)
         {
            this.underlineButton.selected = tf.underline;
         }
         if(!this.previousTextFormat || this.previousTextFormat.align != tf.align)
         {
            if(tf.align == "left")
            {
               this.alignButtons.selectedIndex = 0;
            }
            else if(tf.align == "center")
            {
               this.alignButtons.selectedIndex = 1;
            }
            else if(tf.align == "right")
            {
               this.alignButtons.selectedIndex = 2;
            }
            else if(tf.align == "justify")
            {
               this.alignButtons.selectedIndex = 3;
            }
         }
         if(!this.previousTextFormat || this.previousTextFormat.bullet != tf.bullet)
         {
            this.bulletButton.selected = tf.bullet;
         }
         if(!this.previousTextFormat || this.previousTextFormat.url != tf.url)
         {
            this.linkTextInput.text = tf.url == "" || tf.url == null ? this.defaultLinkProtocol : tf.url;
         }
         if(this.textArea.getTextField().defaultTextFormat != tf)
         {
            this.textArea.getTextField().defaultTextFormat = tf;
         }
         this.previousTextFormat = tf;
         this.textFormatChanged = false;
         this.lastCaretIndex = this.textArea.getTextField().caretIndex;
         this.invalidateToolBarFlag = false;
      }
      
      private function setComboSelection(combo:ComboBox, val:String) : void
      {
         var length:uint = uint(combo.dataProvider.length);
         for(var i:uint = 0; i < length; i++)
         {
            if(combo.dataProvider.getItemAt(i).toLowerCase() == val.toLowerCase())
            {
               combo.selectedIndex = i;
               return;
            }
         }
         combo.selectedIndex = -1;
         combo.validateNow();
         combo.text = val;
      }
      
      private function systemManager_mouseUpHandler(event:MouseEvent) : void
      {
         if(this.lastCaretIndex != this.textArea.getTextField().caretIndex)
         {
            this.getTextStyles();
         }
         else if(this.textArea.getTextField().selectionBeginIndex == this.textArea.getTextField().selectionEndIndex)
         {
            this.linkTextInput.enabled = false;
         }
         else
         {
            this.linkTextInput.enabled = true;
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
      }
      
      private function _RichTextEditor_Array1_i() : Array
      {
         var _loc1_:Array = ["_sans","_serif","_typewriter","Arial","Courier","Courier New","Geneva","Georgia","Helvetica","Times New Roman","Times","Verdana"];
         this.fontFamilyArray = _loc1_;
         BindingManager.executeBindings(this,"fontFamilyArray",this.fontFamilyArray);
         return _loc1_;
      }
      
      private function _RichTextEditor_Array2_i() : Array
      {
         var _loc1_:Array = ["8","9","10","11","12","14","16","18","20","22","24","26","28","36","48","72"];
         this.fontSizeArray = _loc1_;
         BindingManager.executeBindings(this,"fontSizeArray",this.fontSizeArray);
         return _loc1_;
      }
      
      public function __textArea_change(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      public function __textArea_valueCommit(event:FlexEvent) : void
      {
         dispatchEvent(event);
      }
      
      public function __textArea_keyUp(event:KeyboardEvent) : void
      {
         this.getTextStyles();
      }
      
      public function __textArea_keyDown(event:KeyboardEvent) : void
      {
         if(this.textFormatChanged)
         {
            this.textArea.getTextField().defaultTextFormat = this.previousTextFormat;
            this.textFormatChanged = false;
         }
      }
      
      public function __textArea_mouseDown(event:MouseEvent) : void
      {
         systemManager.addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
      }
      
      public function __fontFamilyCombo_creationComplete(event:FlexEvent) : void
      {
         this.getTextStyles();
         this.lastCaretIndex = -1;
      }
      
      public function __fontFamilyCombo_close(event:DropdownEvent) : void
      {
         this.setTextStyles("font");
      }
      
      public function __fontFamilyCombo_enter(event:FlexEvent) : void
      {
         this.setTextStyles("font");
      }
      
      public function __fontSizeCombo_close(event:DropdownEvent) : void
      {
         this.setTextStyles("size");
      }
      
      public function __fontSizeCombo_enter(event:FlexEvent) : void
      {
         this.setTextStyles("size");
      }
      
      public function __boldButton_click(event:MouseEvent) : void
      {
         this.setTextStyles("bold",event.currentTarget.selected);
      }
      
      public function __italicButton_click(event:MouseEvent) : void
      {
         this.setTextStyles("italic",event.currentTarget.selected);
      }
      
      public function __underlineButton_click(event:MouseEvent) : void
      {
         this.setTextStyles("underline",event.currentTarget.selected);
      }
      
      public function __colorPicker_close(event:DropdownEvent) : void
      {
         this.setTextStyles("color");
      }
      
      public function __alignButtons_itemClick(event:ItemClickEvent) : void
      {
         this.setTextStyles("align",ToggleButtonBar(event.currentTarget).dataProvider.getItemAt(ToggleButtonBar(event.currentTarget).selectedIndex).action);
      }
      
      public function __bulletButton_click(event:MouseEvent) : void
      {
         this.setTextStyles("bullet",event.currentTarget.selected);
      }
      
      public function __linkTextInput_focusOut(event:FocusEvent) : void
      {
         if(this.linkTextCommitted)
         {
            trace("already committed");
            this.linkTextCommitted = false;
         }
         else
         {
            trace("not committed");
            this.setTextStyles("url",this.linkTextInput.text);
            this.linkTextInput.text = this.defaultLinkProtocol;
         }
      }
      
      public function __linkTextInput_enter(event:FlexEvent) : void
      {
         this.setTextStyles("url",this.linkTextInput.text);
         this.linkTextInput.text = this.defaultLinkProtocol;
         this.linkTextCommitted = true;
      }
      
      private function _RichTextEditor_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"fontFamilyCombo.dataProvider","fontFamilyArray");
         result[1] = new Binding(this,null,null,"fontSizeCombo.dataProvider","fontSizeArray");
         result[2] = new Binding(this,function():Number
         {
            return alignButtons.height;
         },null,"_RichTextEditor_VRule1.height");
         result[3] = new Binding(this,function():Number
         {
            return linkTextInput.height;
         },null,"_RichTextEditor_VRule2.height");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get alignButtons() : ToggleButtonBar
      {
         return this._1462779716alignButtons;
      }
      
      public function set alignButtons(param1:ToggleButtonBar) : void
      {
         var _loc2_:Object = this._1462779716alignButtons;
         if(_loc2_ !== param1)
         {
            this._1462779716alignButtons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alignButtons",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get boldButton() : Button
      {
         return this._1040280041boldButton;
      }
      
      public function set boldButton(param1:Button) : void
      {
         var _loc2_:Object = this._1040280041boldButton;
         if(_loc2_ !== param1)
         {
            this._1040280041boldButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boldButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bulletButton() : Button
      {
         return this._97660628bulletButton;
      }
      
      public function set bulletButton(param1:Button) : void
      {
         var _loc2_:Object = this._97660628bulletButton;
         if(_loc2_ !== param1)
         {
            this._97660628bulletButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bulletButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colorPicker() : ColorPicker
      {
         return this._885706193colorPicker;
      }
      
      public function set colorPicker(param1:ColorPicker) : void
      {
         var _loc2_:Object = this._885706193colorPicker;
         if(_loc2_ !== param1)
         {
            this._885706193colorPicker = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colorPicker",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fontFamilyArray() : Array
      {
         return this._610088570fontFamilyArray;
      }
      
      public function set fontFamilyArray(param1:Array) : void
      {
         var _loc2_:Object = this._610088570fontFamilyArray;
         if(_loc2_ !== param1)
         {
            this._610088570fontFamilyArray = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontFamilyArray",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fontFamilyCombo() : ComboBox
      {
         return this._608335685fontFamilyCombo;
      }
      
      public function set fontFamilyCombo(param1:ComboBox) : void
      {
         var _loc2_:Object = this._608335685fontFamilyCombo;
         if(_loc2_ !== param1)
         {
            this._608335685fontFamilyCombo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontFamilyCombo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fontSizeArray() : Array
      {
         return this._1657931959fontSizeArray;
      }
      
      public function set fontSizeArray(param1:Array) : void
      {
         var _loc2_:Object = this._1657931959fontSizeArray;
         if(_loc2_ !== param1)
         {
            this._1657931959fontSizeArray = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontSizeArray",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fontSizeCombo() : ComboBox
      {
         return this._1656179074fontSizeCombo;
      }
      
      public function set fontSizeCombo(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1656179074fontSizeCombo;
         if(_loc2_ !== param1)
         {
            this._1656179074fontSizeCombo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontSizeCombo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get italicButton() : Button
      {
         return this._1138485634italicButton;
      }
      
      public function set italicButton(param1:Button) : void
      {
         var _loc2_:Object = this._1138485634italicButton;
         if(_loc2_ !== param1)
         {
            this._1138485634italicButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"italicButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get linkTextInput() : TextInput
      {
         return this._343678915linkTextInput;
      }
      
      public function set linkTextInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._343678915linkTextInput;
         if(_loc2_ !== param1)
         {
            this._343678915linkTextInput = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"linkTextInput",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textArea() : TextArea
      {
         return this._1004197030textArea;
      }
      
      public function set textArea(param1:TextArea) : void
      {
         var _loc2_:Object = this._1004197030textArea;
         if(_loc2_ !== param1)
         {
            this._1004197030textArea = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textArea",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get toolBar2() : HBox
      {
         return this._984131529toolBar2;
      }
      
      public function set toolBar2(param1:HBox) : void
      {
         var _loc2_:Object = this._984131529toolBar2;
         if(_loc2_ !== param1)
         {
            this._984131529toolBar2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolBar2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get toolbar() : ToolBar
      {
         return this._1140094085toolbar;
      }
      
      public function set toolbar(param1:ToolBar) : void
      {
         var _loc2_:Object = this._1140094085toolbar;
         if(_loc2_ !== param1)
         {
            this._1140094085toolbar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolbar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get underlineButton() : Button
      {
         return this._2023461150underlineButton;
      }
      
      public function set underlineButton(param1:Button) : void
      {
         var _loc2_:Object = this._2023461150underlineButton;
         if(_loc2_ !== param1)
         {
            this._2023461150underlineButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"underlineButton",_loc2_,param1));
            }
         }
      }
   }
}


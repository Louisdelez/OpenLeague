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
   import mx.core.IUITextField;
   import mx.core.UIComponentDescriptor;
   import mx.core.UITextFormat;
   import mx.core.mx_internal;
   import mx.events.DropdownEvent;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
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
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      [Embed(source="assets/icon_style_italic.png")]
      private var _embed_mxml_assets_icon_style_italic_png_1882511331:Class = RichTextEditor__embed_mxml_assets_icon_style_italic_png_1882511331;
      
      private var _text:String = "";
      
      private var htmlTextChanged:Boolean = false;
      
      public var alignToolTip:String = "Align";
      
      [Embed(source="assets/icon_align_center.png")]
      private var _embed_mxml_assets_icon_align_center_png_1788044413:Class = RichTextEditor__embed_mxml_assets_icon_align_center_png_1788044413;
      
      private var _2023461150underlineButton:Button;
      
      private var _1138485634italicButton:Button;
      
      private var _1004197030textArea:TextArea;
      
      private var invalidateToolBarFlag:Boolean = false;
      
      private var lastCaretIndex:int = -1;
      
      public var _RichTextEditor_VRule1:VRule;
      
      public var _RichTextEditor_VRule2:VRule;
      
      [Embed(source="assets/icon_bullet.png")]
      private var _embed_mxml_assets_icon_bullet_png_582039011:Class = RichTextEditor__embed_mxml_assets_icon_bullet_png_582039011;
      
      private var _343678915linkTextInput:TextInput;
      
      [Embed(source="assets/icon_style_bold.png")]
      private var _embed_mxml_assets_icon_style_bold_png_1158484403:Class = RichTextEditor__embed_mxml_assets_icon_style_bold_png_1158484403;
      
      [Embed(source="assets/icon_align_left.png")]
      private var _embed_mxml_assets_icon_align_left_png_1211420387:Class = RichTextEditor__embed_mxml_assets_icon_align_left_png_1211420387;
      
      private var _1462779716alignButtons:ToggleButtonBar;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      [Embed(source="assets/icon_style_underline.png")]
      private var _embed_mxml_assets_icon_style_underline_png_1600285309:Class = RichTextEditor__embed_mxml_assets_icon_style_underline_png_1600285309;
      
      private var _showControlBar:Boolean = true;
      
      public var underlineToolTip:String = "Underline";
      
      private var _984131529toolBar2:HBox;
      
      public var bulletToolTip:String = "Bullet";
      
      public var linkToolTip:String = "Link";
      
      public var italicToolTip:String = "Italic";
      
      mx_internal var _watchers:Array = [];
      
      private var firstTime:Boolean = true;
      
      public var boldToolTip:String = "Bold";
      
      private var textFormatChanged:Boolean = false;
      
      private var _608335685fontFamilyCombo:ComboBox;
      
      [Embed(source="assets/icon_align_right.png")]
      private var _embed_mxml_assets_icon_align_right_png_1583119693:Class = RichTextEditor__embed_mxml_assets_icon_align_right_png_1583119693;
      
      [Embed(source="assets/icon_align_justify.png")]
      private var _embed_mxml_assets_icon_align_justify_png_1419938291:Class = RichTextEditor__embed_mxml_assets_icon_align_justify_png_1419938291;
      
      private var _1140094085toolbar:ToolBar;
      
      private var textChanged:Boolean = false;
      
      public var fontFamilyToolTip:String = "Font Family";
      
      private var _610088570fontFamilyArray:Array;
      
      public var fontSizeToolTip:String = "Font Size";
      
      private var _1040280041boldButton:Button;
      
      private var _htmlText:String = "";
      
      public var colorPickerToolTip:String = "Color";
      
      private var previousTextFormat:TextFormat = null;
      
      private var _97660628bulletButton:Button;
      
      private var _1656179074fontSizeCombo:ComboBox;
      
      private var showControlBarChanged:Boolean = false;
      
      private var _defaultLinkProtocol:String = "http://";
      
      private var showToolTipsChanged:Boolean = false;
      
      private var _showToolTips:Boolean = false;
      
      private var _885706193colorPicker:ColorPicker;
      
      private var linkTextCommitted:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
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
                                          this.icon = _embed_mxml_assets_icon_style_bold_png_1158484403;
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
                                          this.icon = _embed_mxml_assets_icon_style_italic_png_1882511331;
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
                                          this.icon = _embed_mxml_assets_icon_style_underline_png_1600285309;
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
                                       "icon":_embed_mxml_assets_icon_align_left_png_1211420387,
                                       "action":"left"
                                    },{
                                       "icon":_embed_mxml_assets_icon_align_center_png_1788044413,
                                       "action":"center"
                                    },{
                                       "icon":_embed_mxml_assets_icon_align_right_png_1583119693,
                                       "action":"right"
                                    },{
                                       "icon":_embed_mxml_assets_icon_align_justify_png_1419938291,
                                       "action":"justify"
                                    }]};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"bulletButton",
                                 "events":{"click":"__bulletButton_click"},
                                 "stylesFactory":function():void
                                 {
                                    this.icon = _embed_mxml_assets_icon_bullet_png_582039011;
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
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindings:Array = [];
      
      private var _1657931959fontSizeArray:Array;
      
      public function RichTextEditor()
      {
         super();
         mx_internal::_document = this;
         this.minWidth = 220;
         this.minHeight = 200;
         this.width = 325;
         this.height = 300;
         _RichTextEditor_Array1_i();
         _RichTextEditor_Array2_i();
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         RichTextEditor._watcherSetupUtil = param1;
      }
      
      public function set fontSizeCombo(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1656179074fontSizeCombo;
         if(_loc2_ !== param1)
         {
            this._1656179074fontSizeCombo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontSizeCombo",_loc2_,param1));
         }
      }
      
      public function set italicButton(param1:Button) : void
      {
         var _loc2_:Object = this._1138485634italicButton;
         if(_loc2_ !== param1)
         {
            this._1138485634italicButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"italicButton",_loc2_,param1));
         }
      }
      
      private function _RichTextEditor_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return fontFamilyArray;
         },function(param1:Object):void
         {
            fontFamilyCombo.dataProvider = param1;
         },"fontFamilyCombo.dataProvider");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return fontSizeArray;
         },function(param1:Object):void
         {
            fontSizeCombo.dataProvider = param1;
         },"fontSizeCombo.dataProvider");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return alignButtons.height;
         },function(param1:Number):void
         {
            _RichTextEditor_VRule1.height = param1;
         },"_RichTextEditor_VRule1.height");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return linkTextInput.height;
         },function(param1:Number):void
         {
            _RichTextEditor_VRule2.height = param1;
         },"_RichTextEditor_VRule2.height");
         result[3] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get linkTextInput() : TextInput
      {
         return this._343678915linkTextInput;
      }
      
      [Inspectable(defaultValue="false")]
      public function get showToolTips() : Boolean
      {
         return _showToolTips;
      }
      
      public function set toolbar(param1:ToolBar) : void
      {
         var _loc2_:Object = this._1140094085toolbar;
         if(_loc2_ !== param1)
         {
            this._1140094085toolbar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolbar",_loc2_,param1));
         }
      }
      
      public function set fontFamilyArray(param1:Array) : void
      {
         var _loc2_:Object = this._610088570fontFamilyArray;
         if(_loc2_ !== param1)
         {
            this._610088570fontFamilyArray = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontFamilyArray",_loc2_,param1));
         }
      }
      
      public function __textArea_keyUp(event:KeyboardEvent) : void
      {
         getTextStyles();
      }
      
      public function __fontSizeCombo_close(event:DropdownEvent) : void
      {
         setTextStyles("size");
      }
      
      public function set showToolTips(value:Boolean) : void
      {
         _showToolTips = value;
         showToolTipsChanged = true;
         invalidateProperties();
      }
      
      public function __textArea_mouseDown(event:MouseEvent) : void
      {
         systemManager.addEventListener(MouseEvent.MOUSE_UP,systemManager_mouseUpHandler,true);
      }
      
      [Bindable(event="propertyChange")]
      public function get underlineButton() : Button
      {
         return this._2023461150underlineButton;
      }
      
      [Bindable(event="propertyChange")]
      public function get bulletButton() : Button
      {
         return this._97660628bulletButton;
      }
      
      public function __colorPicker_close(event:DropdownEvent) : void
      {
         setTextStyles("color");
      }
      
      public function __fontFamilyCombo_creationComplete(event:FlexEvent) : void
      {
         getTextStyles();
         lastCaretIndex = -1;
      }
      
      [Inspectable(category="General")]
      [NonCommittingChangeEvent("change")]
      [CollapseWhiteSpace]
      [Bindable("valueCommit")]
      public function get text() : String
      {
         return Boolean(textArea) ? textArea.text : _text;
      }
      
      public function set boldButton(param1:Button) : void
      {
         var _loc2_:Object = this._1040280041boldButton;
         if(_loc2_ !== param1)
         {
            this._1040280041boldButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boldButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get boldButton() : Button
      {
         return this._1040280041boldButton;
      }
      
      public function __linkTextInput_focusOut(event:FocusEvent) : void
      {
         if(linkTextCommitted)
         {
            trace("already committed");
            linkTextCommitted = false;
         }
         else
         {
            trace("not committed");
            setTextStyles("url",linkTextInput.text);
            linkTextInput.text = defaultLinkProtocol;
         }
      }
      
      public function set defaultLinkProtocol(value:String) : void
      {
         _defaultLinkProtocol = value;
         if(Boolean(linkTextInput))
         {
            linkTextInput.text = _defaultLinkProtocol;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get toolBar2() : HBox
      {
         return this._984131529toolBar2;
      }
      
      public function __bulletButton_click(event:MouseEvent) : void
      {
         setTextStyles("bullet",event.currentTarget.selected);
      }
      
      public function __boldButton_click(event:MouseEvent) : void
      {
         setTextStyles("bold",event.currentTarget.selected);
      }
      
      public function __underlineButton_click(event:MouseEvent) : void
      {
         setTextStyles("underline",event.currentTarget.selected);
      }
      
      public function __alignButtons_itemClick(event:ItemClickEvent) : void
      {
         setTextStyles("align",ToggleButtonBar(event.currentTarget).dataProvider.getItemAt(ToggleButtonBar(event.currentTarget).selectedIndex).action);
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get showControlBar() : Boolean
      {
         return _showControlBar;
      }
      
      public function __textArea_change(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      public function set text(value:String) : void
      {
         _text = value;
         textChanged = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinWidth = 220;
         measuredWidth = 320;
         measuredMinHeight = 200;
         measuredHeight = 300;
      }
      
      [Bindable(event="propertyChange")]
      public function get fontSizeArray() : Array
      {
         return this._1657931959fontSizeArray;
      }
      
      private function _RichTextEditor_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = fontFamilyArray;
         _loc1_ = fontSizeArray;
         _loc1_ = alignButtons.height;
         _loc1_ = linkTextInput.height;
      }
      
      private function getTextStyles() : void
      {
         var tf:TextFormat = null;
         var carIndex:int = 0;
         var tfNext:TextFormat = null;
         if(!textArea)
         {
            return;
         }
         var beginIndex:int = textArea.getTextField().selectionBeginIndex;
         var endIndex:int = textArea.getTextField().selectionEndIndex;
         if(beginIndex == endIndex)
         {
            linkTextInput.enabled = false;
         }
         else
         {
            linkTextInput.enabled = true;
         }
         if(textFormatChanged)
         {
            previousTextFormat = null;
         }
         if(beginIndex == endIndex)
         {
            tf = textArea.getTextField().defaultTextFormat;
            if(tf.url != "")
            {
               carIndex = textArea.getTextField().caretIndex;
               if(carIndex < textArea.getTextField().length)
               {
                  tfNext = textArea.getTextField().getTextFormat(carIndex,carIndex + 1);
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
            tf = textArea.getTextField().getTextFormat(beginIndex,endIndex);
         }
         if(!previousTextFormat || previousTextFormat.font != tf.font)
         {
            setComboSelection(fontFamilyCombo,Boolean(tf.font) ? tf.font : "");
         }
         if(!previousTextFormat || previousTextFormat.size != tf.size)
         {
            setComboSelection(fontSizeCombo,Boolean(tf.size) ? String(tf.size) : "");
         }
         if(!previousTextFormat || previousTextFormat.color != tf.color)
         {
            colorPicker.selectedColor = Number(tf.color);
         }
         if(!previousTextFormat || previousTextFormat.bold != tf.bold)
         {
            boldButton.selected = tf.bold;
         }
         if(!previousTextFormat || previousTextFormat.italic != tf.italic)
         {
            italicButton.selected = tf.italic;
         }
         if(!previousTextFormat || previousTextFormat.underline != tf.underline)
         {
            underlineButton.selected = tf.underline;
         }
         if(!previousTextFormat || previousTextFormat.align != tf.align)
         {
            if(tf.align == "left")
            {
               alignButtons.selectedIndex = 0;
            }
            else if(tf.align == "center")
            {
               alignButtons.selectedIndex = 1;
            }
            else if(tf.align == "right")
            {
               alignButtons.selectedIndex = 2;
            }
            else if(tf.align == "justify")
            {
               alignButtons.selectedIndex = 3;
            }
         }
         if(!previousTextFormat || previousTextFormat.bullet != tf.bullet)
         {
            bulletButton.selected = tf.bullet;
         }
         if(!previousTextFormat || previousTextFormat.url != tf.url)
         {
            linkTextInput.text = tf.url == "" || tf.url == null ? defaultLinkProtocol : tf.url;
         }
         if(textArea.getTextField().defaultTextFormat != tf)
         {
            textArea.getTextField().defaultTextFormat = tf;
         }
         previousTextFormat = tf;
         textFormatChanged = false;
         lastCaretIndex = textArea.getTextField().caretIndex;
         invalidateToolBarFlag = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get textArea() : TextArea
      {
         return this._1004197030textArea;
      }
      
      public function __italicButton_click(event:MouseEvent) : void
      {
         setTextStyles("italic",event.currentTarget.selected);
      }
      
      public function set toolBar2(param1:HBox) : void
      {
         var _loc2_:Object = this._984131529toolBar2;
         if(_loc2_ !== param1)
         {
            this._984131529toolBar2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolBar2",_loc2_,param1));
         }
      }
      
      private function setTextStyles(type:String, value:Object = null) : void
      {
         var tf:TextFormat = null;
         var fontSize:uint = 0;
         var beginIndex:int = textArea.getTextField().selectionBeginIndex;
         var endIndex:int = textArea.getTextField().selectionEndIndex;
         if(beginIndex == endIndex)
         {
            tf = previousTextFormat;
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
            beginIndex = textArea.getTextField().getFirstCharInParagraph(beginIndex) - 1;
            beginIndex = Math.max(0,beginIndex);
            endIndex = textArea.getTextField().getFirstCharInParagraph(endIndex) + textArea.getTextField().getParagraphLength(endIndex) - 1;
            tf[type] = value;
            previousTextFormat[type] = value;
            if(!endIndex)
            {
               textArea.getTextField().defaultTextFormat = tf;
            }
         }
         else if(type == "font")
         {
            tf[type] = fontFamilyCombo.text;
         }
         else if(type == "size")
         {
            fontSize = uint(fontSizeCombo.text);
            if(fontSize > 0)
            {
               tf[type] = fontSize;
            }
         }
         else if(type == "color")
         {
            tf[type] = uint(colorPicker.selectedColor);
         }
         else if(type == "url")
         {
            if(value != defaultLinkProtocol && value != "")
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
         textFormatChanged = true;
         if(beginIndex == endIndex)
         {
            previousTextFormat = tf;
         }
         else
         {
            textArea.getTextField().setTextFormat(tf,beginIndex,endIndex);
         }
         dispatchEvent(new Event("change"));
         var caretIndex:int = textArea.getTextField().caretIndex;
         var lineIndex:int = textArea.getTextField().getLineIndexOfChar(caretIndex);
         textArea.invalidateDisplayList();
         textArea.validateDisplayList();
         while(lineIndex >= textArea.getTextField().bottomScrollV)
         {
            ++textArea.verticalScrollPosition;
         }
         callLater(textArea.setFocus);
      }
      
      public function set underlineButton(param1:Button) : void
      {
         var _loc2_:Object = this._2023461150underlineButton;
         if(_loc2_ !== param1)
         {
            this._2023461150underlineButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"underlineButton",_loc2_,param1));
         }
      }
      
      public function set fontFamilyCombo(param1:ComboBox) : void
      {
         var _loc2_:Object = this._608335685fontFamilyCombo;
         if(_loc2_ !== param1)
         {
            this._608335685fontFamilyCombo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontFamilyCombo",_loc2_,param1));
         }
      }
      
      [Inspectable(category="General")]
      [NonCommittingChangeEvent("change")]
      [CollapseWhiteSpace]
      [Bindable("valueCommit")]
      public function get htmlText() : String
      {
         return Boolean(textArea) ? textArea.htmlText : _htmlText;
      }
      
      public function __fontFamilyCombo_enter(event:FlexEvent) : void
      {
         setTextStyles("font");
      }
      
      public function __linkTextInput_enter(event:FlexEvent) : void
      {
         setTextStyles("url",linkTextInput.text);
         linkTextInput.text = defaultLinkProtocol;
         linkTextCommitted = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get fontSizeCombo() : ComboBox
      {
         return this._1656179074fontSizeCombo;
      }
      
      public function set alignButtons(param1:ToggleButtonBar) : void
      {
         var _loc2_:Object = this._1462779716alignButtons;
         if(_loc2_ !== param1)
         {
            this._1462779716alignButtons = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alignButtons",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get italicButton() : Button
      {
         return this._1138485634italicButton;
      }
      
      public function __textArea_valueCommit(event:FlexEvent) : void
      {
         dispatchEvent(event);
      }
      
      public function get selection() : TextRange
      {
         return new TextRange(this,true);
      }
      
      private function _RichTextEditor_Array2_i() : Array
      {
         var temp:Array = ["8","9","10","11","12","14","16","18","20","22","24","26","28","36","48","72"];
         fontSizeArray = temp;
         return temp;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:RichTextEditor = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         bindings = _RichTextEditor_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_mx_controls_RichTextEditorWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get fontFamilyArray() : Array
      {
         return this._610088570fontFamilyArray;
      }
      
      public function set fontSizeArray(param1:Array) : void
      {
         var _loc2_:Object = this._1657931959fontSizeArray;
         if(_loc2_ !== param1)
         {
            this._1657931959fontSizeArray = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fontSizeArray",_loc2_,param1));
         }
      }
      
      [Inspectable(defaultValue="http://")]
      public function get defaultLinkProtocol() : String
      {
         return _defaultLinkProtocol;
      }
      
      public function __textArea_keyDown(event:KeyboardEvent) : void
      {
         if(textFormatChanged)
         {
            textArea.getTextField().defaultTextFormat = previousTextFormat;
            textFormatChanged = false;
         }
      }
      
      public function set colorPicker(param1:ColorPicker) : void
      {
         var _loc2_:Object = this._885706193colorPicker;
         if(_loc2_ !== param1)
         {
            this._885706193colorPicker = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colorPicker",_loc2_,param1));
         }
      }
      
      public function __fontFamilyCombo_close(event:DropdownEvent) : void
      {
         setTextStyles("font");
      }
      
      public function set showControlBar(value:Boolean) : void
      {
         _showControlBar = value;
         showControlBarChanged = true;
         invalidateProperties();
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
      
      public function set textArea(param1:TextArea) : void
      {
         var _loc2_:Object = this._1004197030textArea;
         if(_loc2_ !== param1)
         {
            this._1004197030textArea = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textArea",_loc2_,param1));
         }
      }
      
      public function set bulletButton(param1:Button) : void
      {
         var _loc2_:Object = this._97660628bulletButton;
         if(_loc2_ !== param1)
         {
            this._97660628bulletButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bulletButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fontFamilyCombo() : ComboBox
      {
         return this._608335685fontFamilyCombo;
      }
      
      [Bindable(event="propertyChange")]
      public function get alignButtons() : ToggleButtonBar
      {
         return this._1462779716alignButtons;
      }
      
      public function set linkTextInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._343678915linkTextInput;
         if(_loc2_ !== param1)
         {
            this._343678915linkTextInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"linkTextInput",_loc2_,param1));
         }
      }
      
      override protected function commitProperties() : void
      {
         var textAreaStyleName:String = null;
         var tf:UITextFormat = null;
         super.commitProperties();
         if(firstTime)
         {
            firstTime = false;
            textAreaStyleName = getStyle("textAreaStyleName");
            if(Boolean(textAreaStyleName))
            {
               textArea.styleName = textAreaStyleName;
            }
            textArea.getTextField().alwaysShowSelection = true;
         }
         if(showControlBarChanged)
         {
            if(_showControlBar)
            {
               controlBar.height = NaN;
               controlBar.visible = true;
            }
            else
            {
               controlBar.height = 0;
               controlBar.visible = false;
            }
            showControlBarChanged = false;
         }
         if(showToolTipsChanged)
         {
            if(_showToolTips)
            {
               fontFamilyCombo.toolTip = fontFamilyToolTip;
               fontSizeCombo.toolTip = fontSizeToolTip;
               boldButton.toolTip = boldToolTip;
               italicButton.toolTip = italicToolTip;
               underlineButton.toolTip = underlineToolTip;
               colorPicker.toolTip = colorPickerToolTip;
               alignButtons.toolTip = alignToolTip;
               bulletButton.toolTip = bulletToolTip;
               linkTextInput.toolTip = linkToolTip;
            }
            else
            {
               fontFamilyCombo.toolTip = "";
               fontSizeCombo.toolTip = "";
               boldButton.toolTip = "";
               italicButton.toolTip = "";
               underlineButton.toolTip = "";
               colorPicker.toolTip = "";
               alignButtons.toolTip = "";
               bulletButton.toolTip = "";
               linkTextInput.toolTip = "";
            }
            showToolTipsChanged = false;
         }
         if(textChanged || htmlTextChanged)
         {
            tf = IUITextField(textArea.getTextField()).getUITextFormat();
            tf.bullet = false;
            textArea.getTextField().defaultTextFormat = tf;
            if(textChanged)
            {
               textArea.text = _text;
               textChanged = false;
            }
            else
            {
               textArea.htmlText = _htmlText;
               htmlTextChanged = false;
            }
         }
      }
      
      private function _RichTextEditor_Array1_i() : Array
      {
         var temp:Array = ["_sans","_serif","_typewriter","Arial","Courier","Courier New","Geneva","Georgia","Helvetica","Times New Roman","Times","Verdana"];
         fontFamilyArray = temp;
         return temp;
      }
      
      [Bindable(event="propertyChange")]
      public function get toolbar() : ToolBar
      {
         return this._1140094085toolbar;
      }
      
      [Bindable(event="propertyChange")]
      public function get colorPicker() : ColorPicker
      {
         return this._885706193colorPicker;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var textAreaStyleName:String = null;
         super.styleChanged(styleProp);
         if(styleProp == null || styleProp == "textAreaStyleName")
         {
            if(Boolean(textArea))
            {
               textAreaStyleName = getStyle("textAreaStyleName");
               textArea.styleName = textAreaStyleName;
            }
         }
         if(!invalidateToolBarFlag)
         {
            invalidateToolBarFlag = true;
            callLater(getTextStyles);
         }
      }
      
      private function systemManager_mouseUpHandler(event:MouseEvent) : void
      {
         if(lastCaretIndex != textArea.getTextField().caretIndex)
         {
            getTextStyles();
         }
         else if(textArea.getTextField().selectionBeginIndex == textArea.getTextField().selectionEndIndex)
         {
            linkTextInput.enabled = false;
         }
         else
         {
            linkTextInput.enabled = true;
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,systemManager_mouseUpHandler,true);
      }
      
      public function set htmlText(value:String) : void
      {
         _htmlText = value;
         htmlTextChanged = true;
         invalidateProperties();
      }
      
      public function __fontSizeCombo_enter(event:FlexEvent) : void
      {
         setTextStyles("size");
      }
   }
}


package mx.core
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flashx.textLayout.elements.GlobalSettings;
   import mx.automation.IAutomationObject;
   import mx.managers.ISystemManager;
   import mx.managers.IToolTipManagerClient;
   import mx.managers.SystemManager;
   import mx.managers.ToolTipManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManager;
   import mx.styles.StyleProtoChain;
   import mx.utils.NameUtil;
   import mx.utils.StringUtil;
   import spark.utils.TextUtil;
   
   [ResourceBundle("core")]
   public class UIFTETextField extends FTETextField implements IAutomationObject, IIMESupport, IFlexModule, IInvalidating, ISimpleStyleClient, IToolTipManagerClient, IUITextField
   {
      
      private static var truncationIndicatorResource:String;
      
      private static var noEmbeddedFonts:Boolean;
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const TEXT_WIDTH_PADDING:int = 5;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const TEXT_HEIGHT_PADDING:int = 4;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var debuggingBorders:Boolean = false;
      
      private var cachedTextFormat:TextFormat;
      
      private var cachedEmbeddedFont:EmbeddedFont = null;
      
      private var invalidateDisplayListFlag:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var styleChangedFlag:Boolean = true;
      
      private var explicitHTMLText:String = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var explicitColor:uint = 4294967295;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var untruncatedText:String;
      
      private var useExplicitWidth:Boolean = false;
      
      private var useExplicitHeight:Boolean = false;
      
      private var mirror:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _parent:DisplayObjectContainer;
      
      private var _x:Number = 0;
      
      private var _automationDelegate:IAutomationObject;
      
      private var _automationName:String;
      
      private var _document:Object;
      
      private var _enabled:Boolean = true;
      
      private var _explicitHeight:Number;
      
      private var _explicitWidth:Number;
      
      private var _ignorePadding:Boolean = true;
      
      private var _imeMode:String = null;
      
      private var _includeInLayout:Boolean = true;
      
      private var _inheritingStyles:Object = StyleProtoChain.STYLE_UNINITIALIZED;
      
      private var _initialized:Boolean = false;
      
      private var _moduleFactory:IFlexModuleFactory;
      
      private var _nestLevel:int = 0;
      
      private var _nonInheritingStyles:Object = StyleProtoChain.STYLE_UNINITIALIZED;
      
      private var _processedDescriptors:Boolean = true;
      
      private var _styleName:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _toolTip:String;
      
      private var _updateCompletePendingFlag:Boolean = false;
      
      private var _owner:DisplayObjectContainer;
      
      public function UIFTETextField()
      {
         super();
         GlobalSettings.resourceStringFunction = TextUtil.getResourceString;
         super.text = "";
         focusRect = false;
         selectable = false;
         tabEnabled = false;
         if(debuggingBorders)
         {
            border = true;
         }
         if(!truncationIndicatorResource)
         {
            truncationIndicatorResource = this.resourceManager.getString("core","truncationIndicator");
         }
         addEventListener(Event.CHANGE,this.changeHandler);
         addEventListener("textFieldStyleChange",this.textFieldStyleChangeHandler);
         this.resourceManager.addEventListener(Event.CHANGE,this.resourceManager_changeHandler,false,0,true);
      }
      
      private static function get embeddedFontRegistry() : IEmbeddedFontRegistry
      {
         if(!_embeddedFontRegistry && !noEmbeddedFonts)
         {
            try
            {
               _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            }
            catch(e:Error)
            {
               noEmbeddedFonts = true;
            }
         }
         return _embeddedFontRegistry;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         this.useExplicitHeight = false;
      }
      
      override public function set htmlText(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(this.isHTML && super.htmlText == value)
         {
            return;
         }
         if(Boolean(this.cachedTextFormat) && styleSheet == null)
         {
            defaultTextFormat = this.cachedTextFormat;
         }
         super.htmlText = value;
         this.explicitHTMLText = value;
         if(this.invalidateDisplayListFlag)
         {
            this.validateNow();
         }
      }
      
      override public function get parent() : DisplayObjectContainer
      {
         return Boolean(this._parent) ? this._parent : super.parent;
      }
      
      override public function set text(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(!this.isHTML && super.text == value)
         {
            return;
         }
         super.text = value;
         this.explicitHTMLText = null;
         if(this.invalidateDisplayListFlag)
         {
            this.validateNow();
         }
      }
      
      override public function set textColor(value:uint) : void
      {
         this.setColor(value);
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         if(this.mirror)
         {
            this.validateTransformMatrix();
         }
         this.useExplicitWidth = false;
      }
      
      override public function set x(value:Number) : void
      {
         this._x = value;
         super.x = value;
         if(this.mirror)
         {
            this.validateTransformMatrix();
         }
      }
      
      override public function get x() : Number
      {
         return this.mirror ? this._x : super.x;
      }
      
      public function get automationDelegate() : Object
      {
         return this._automationDelegate;
      }
      
      public function set automationDelegate(value:Object) : void
      {
         this._automationDelegate = value as IAutomationObject;
      }
      
      public function get automationName() : String
      {
         if(Boolean(this._automationName))
         {
            return this._automationName;
         }
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.automationName;
         }
         return "";
      }
      
      public function set automationName(value:String) : void
      {
         this._automationName = value;
      }
      
      public function get automationValue() : Array
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.automationValue;
         }
         return [""];
      }
      
      public function get automationOwner() : DisplayObjectContainer
      {
         return this.owner;
      }
      
      public function get automationParent() : DisplayObjectContainer
      {
         return this.parent;
      }
      
      public function get automationEnabled() : Boolean
      {
         return this.enabled;
      }
      
      public function get automationVisible() : Boolean
      {
         return visible;
      }
      
      public function get baselinePosition() : Number
      {
         var tlm:TextLineMetrics = null;
         var oldAutoSize:String = null;
         if(!this.parent)
         {
            return NaN;
         }
         if(autoSize == TextFieldAutoSize.NONE && (width == 0 || height == 0))
         {
            oldAutoSize = autoSize;
            autoSize = TextFieldAutoSize.LEFT;
         }
         var isEmpty:Boolean = text == "";
         if(isEmpty)
         {
            super.text = "Wj";
         }
         tlm = getLineMetrics(0);
         if(isEmpty)
         {
            super.text = "";
         }
         if(oldAutoSize != null)
         {
            autoSize = oldAutoSize;
         }
         return 2 + tlm.ascent;
      }
      
      public function get className() : String
      {
         return NameUtil.getUnqualifiedClassName(this);
      }
      
      public function get document() : Object
      {
         return this._document;
      }
      
      public function set document(value:Object) : void
      {
         this._document = value;
      }
      
      public function get enableIME() : Boolean
      {
         return type == TextFieldType.INPUT;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         mouseEnabled = value;
         this._enabled = value;
         this.styleChanged("color");
      }
      
      public function get explicitHeight() : Number
      {
         return this._explicitHeight;
      }
      
      public function set explicitHeight(value:Number) : void
      {
         this._explicitHeight = value;
         this.useExplicitHeight = true;
      }
      
      public function get explicitMaxHeight() : Number
      {
         return NaN;
      }
      
      public function get explicitMaxWidth() : Number
      {
         return NaN;
      }
      
      public function get explicitMinHeight() : Number
      {
         return NaN;
      }
      
      public function get explicitMinWidth() : Number
      {
         return NaN;
      }
      
      public function get explicitWidth() : Number
      {
         return this._explicitWidth;
      }
      
      public function set explicitWidth(value:Number) : void
      {
         this._explicitWidth = value;
         this.useExplicitWidth = true;
      }
      
      public function get focusPane() : Sprite
      {
         return null;
      }
      
      public function set focusPane(value:Sprite) : void
      {
      }
      
      public function get ignorePadding() : Boolean
      {
         return this._ignorePadding;
      }
      
      public function set ignorePadding(value:Boolean) : void
      {
         this._ignorePadding = value;
         this.styleChanged(null);
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      public function get includeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function set includeInLayout(value:Boolean) : void
      {
         var p:IInvalidating = null;
         if(this._includeInLayout != value)
         {
            this._includeInLayout = value;
            p = this.parent as IInvalidating;
            if(Boolean(p))
            {
               p.invalidateSize();
               p.invalidateDisplayList();
            }
         }
      }
      
      public function get inheritingStyles() : Object
      {
         return this._inheritingStyles;
      }
      
      public function set inheritingStyles(value:Object) : void
      {
         this._inheritingStyles = value;
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function set initialized(value:Boolean) : void
      {
         this._initialized = value;
      }
      
      private function get isHTML() : Boolean
      {
         return this.explicitHTMLText != null;
      }
      
      public function get isPopUp() : Boolean
      {
         return false;
      }
      
      public function set isPopUp(value:Boolean) : void
      {
      }
      
      public function get maxHeight() : Number
      {
         return UIComponent.DEFAULT_MAX_HEIGHT;
      }
      
      public function get maxWidth() : Number
      {
         return UIComponent.DEFAULT_MAX_WIDTH;
      }
      
      public function get measuredHeight() : Number
      {
         this.validateNow();
         return textHeight + TEXT_HEIGHT_PADDING;
      }
      
      public function get measuredMinHeight() : Number
      {
         return 0;
      }
      
      public function set measuredMinHeight(value:Number) : void
      {
      }
      
      public function get measuredMinWidth() : Number
      {
         return 0;
      }
      
      public function set measuredMinWidth(value:Number) : void
      {
      }
      
      public function get measuredWidth() : Number
      {
         this.validateNow();
         return textWidth + TEXT_WIDTH_PADDING;
      }
      
      public function get minHeight() : Number
      {
         return 0;
      }
      
      public function get minWidth() : Number
      {
         return 0;
      }
      
      [Inspectable(environment="none")]
      public function get moduleFactory() : IFlexModuleFactory
      {
         return this._moduleFactory;
      }
      
      public function set moduleFactory(factory:IFlexModuleFactory) : void
      {
         this._moduleFactory = factory;
      }
      
      public function get nestLevel() : int
      {
         return this._nestLevel;
      }
      
      public function set nestLevel(value:int) : void
      {
         if(value > 1 && this._nestLevel != value)
         {
            this._nestLevel = value;
            StyleProtoChain.initTextField(this);
            this.styleChangedFlag = true;
            this.validateNow();
         }
      }
      
      public function get nonInheritingStyles() : Object
      {
         return this._nonInheritingStyles;
      }
      
      public function set nonInheritingStyles(value:Object) : void
      {
         this._nonInheritingStyles = value;
      }
      
      public function get percentHeight() : Number
      {
         return NaN;
      }
      
      public function set percentHeight(value:Number) : void
      {
      }
      
      public function get percentWidth() : Number
      {
         return NaN;
      }
      
      public function set percentWidth(value:Number) : void
      {
      }
      
      public function get processedDescriptors() : Boolean
      {
         return this._processedDescriptors;
      }
      
      public function set processedDescriptors(value:Boolean) : void
      {
         this._processedDescriptors = value;
      }
      
      public function get styleManager() : IStyleManager2
      {
         return StyleManager.getStyleManager(this.moduleFactory);
      }
      
      public function get styleName() : Object
      {
         return this._styleName;
      }
      
      public function set styleName(value:Object) : void
      {
         if(this._styleName === value)
         {
            return;
         }
         this._styleName = value;
         if(Boolean(this.parent))
         {
            StyleProtoChain.initTextField(this);
            this.styleChanged("styleName");
         }
      }
      
      public function get systemManager() : ISystemManager
      {
         var ui:IUIComponent = null;
         var o:DisplayObject = this.parent;
         while(Boolean(o))
         {
            ui = o as IUIComponent;
            if(Boolean(ui))
            {
               return ui.systemManager;
            }
            o = o.parent;
         }
         return null;
      }
      
      public function set systemManager(value:ISystemManager) : void
      {
      }
      
      public function get nonZeroTextHeight() : Number
      {
         var result:Number = NaN;
         if(super.text == "")
         {
            super.text = "Wj";
            result = textHeight;
            super.text = "";
            return result;
         }
         return textHeight;
      }
      
      public function get toolTip() : String
      {
         return this._toolTip;
      }
      
      public function set toolTip(value:String) : void
      {
         var oldValue:String = this._toolTip;
         this._toolTip = value;
         ToolTipManager.registerToolTip(this,oldValue,value);
      }
      
      public function get tweeningProperties() : Array
      {
         return null;
      }
      
      public function set tweeningProperties(value:Array) : void
      {
      }
      
      public function get updateCompletePendingFlag() : Boolean
      {
         return this._updateCompletePendingFlag;
      }
      
      public function set updateCompletePendingFlag(value:Boolean) : void
      {
         this._updateCompletePendingFlag = value;
      }
      
      override public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1) : void
      {
         if(Boolean(styleSheet))
         {
            return;
         }
         super.setTextFormat(format,beginIndex,endIndex);
         dispatchEvent(new Event("textFormatChange"));
      }
      
      override public function replaceText(beginIndex:int, endIndex:int, newText:String) : void
      {
         super.replaceText(beginIndex,endIndex,newText);
         dispatchEvent(new Event("textReplace"));
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getErrorMessage(key:String, param:String = null) : String
      {
         return this.resourceManager.getString("core",key,[param]);
      }
      
      public function initialize() : void
      {
      }
      
      public function getExplicitOrMeasuredWidth() : Number
      {
         return !isNaN(this.explicitWidth) ? this.explicitWidth : this.measuredWidth;
      }
      
      public function getExplicitOrMeasuredHeight() : Number
      {
         return !isNaN(this.explicitHeight) ? this.explicitHeight : this.measuredHeight;
      }
      
      public function setVisible(visible:Boolean, noEvent:Boolean = false) : void
      {
         this.visible = visible;
      }
      
      public function setFocus() : void
      {
         this.systemManager.stage.focus = this;
      }
      
      public function getUITextFormat() : UITextFormat
      {
         this.validateNow();
         var textFormat:UITextFormat = new UITextFormat(this.creatingSystemManager());
         textFormat.moduleFactory = this.moduleFactory;
         textFormat.copyFrom(getTextFormat());
         textFormat.antiAliasType = antiAliasType;
         textFormat.gridFitType = gridFitType;
         textFormat.sharpness = sharpness;
         textFormat.thickness = thickness;
         textFormat.useFTE = true;
         textFormat.direction = direction;
         textFormat.locale = locale;
         return textFormat;
      }
      
      public function move(x:Number, y:Number) : void
      {
         if(this.x != x)
         {
            this.x = x;
         }
         if(this.y != y)
         {
            this.y = y;
         }
      }
      
      public function setActualSize(w:Number, h:Number) : void
      {
         if(width != w)
         {
            this.width = w;
         }
         if(height != h)
         {
            this.height = h;
         }
      }
      
      public function getStyle(styleProp:String) : *
      {
         if(Boolean(this.styleManager.inheritingStyles[styleProp]))
         {
            return Boolean(this.inheritingStyles) ? this.inheritingStyles[styleProp] : IStyleClient(this.parent).getStyle(styleProp);
         }
         return Boolean(this.nonInheritingStyles) ? this.nonInheritingStyles[styleProp] : IStyleClient(this.parent).getStyle(styleProp);
      }
      
      public function setStyle(styleProp:String, value:*) : void
      {
      }
      
      public function parentChanged(p:DisplayObjectContainer) : void
      {
         if(!p)
         {
            this._parent = null;
            this._nestLevel = 0;
         }
         else if(p is IStyleClient)
         {
            this._parent = p;
         }
         else if(p is SystemManager)
         {
            this._parent = p;
         }
         else
         {
            this._parent = p.parent;
         }
      }
      
      public function styleChanged(styleProp:String) : void
      {
         this.styleChangedFlag = true;
         if(!this.invalidateDisplayListFlag)
         {
            this.invalidateDisplayListFlag = true;
            if("callLater" in this.parent)
            {
               Object(this.parent).callLater(this.validateNow);
            }
         }
      }
      
      public function validateNow() : void
      {
         var oldMirror:Boolean = false;
         var textFormat:TextFormat = null;
         var fontModuleFactory:IFlexModuleFactory = null;
         if(!this.parent)
         {
            return;
         }
         if(this.useExplicitWidth && !isNaN(this.explicitWidth) && width != this.explicitWidth)
         {
            super.width = this.explicitWidth > 4 ? this.explicitWidth : 4;
            if(this.mirror)
            {
               this.validateTransformMatrix();
            }
         }
         if(this.useExplicitHeight && !isNaN(this.explicitHeight) && height != this.explicitHeight)
         {
            super.height = this.explicitHeight;
         }
         if(this.styleChangedFlag)
         {
            oldMirror = this.mirror;
            this.mirror = this.getStyle("layoutDirection") == LayoutDirection.RTL;
            if(this.mirror || oldMirror)
            {
               this.validateTransformMatrix();
            }
         }
         if(this.styleChangedFlag)
         {
            super.direction = this.getStyle("direction");
            super.locale = this.getStyle("locale");
            textFormat = this.getTextStyles();
            if(Boolean(textFormat.font))
            {
               fontModuleFactory = noEmbeddedFonts || !embeddedFontRegistry ? null : embeddedFontRegistry.getAssociatedModuleFactory(textFormat.font,textFormat.bold,textFormat.italic,this,this.moduleFactory,this.creatingSystemManager(),true);
               if(fontModuleFactory != null)
               {
                  fontContext = fontModuleFactory;
                  embedFonts = true;
               }
            }
            else
            {
               embedFonts = this.getStyle("embedFonts");
               if(embedFonts)
               {
                  fontContext = this.moduleFactory;
               }
               else
               {
                  fontContext = null;
               }
            }
            if(this.getStyle("fontAntiAliasType") != undefined)
            {
               antiAliasType = this.getStyle("fontAntiAliasType");
               gridFitType = this.getStyle("fontGridFitType");
               sharpness = this.getStyle("fontSharpness");
               thickness = this.getStyle("fontThickness");
            }
            if(!styleSheet)
            {
               super.setTextFormat(textFormat);
               defaultTextFormat = textFormat;
            }
            dispatchEvent(new Event("textFieldStyleChange"));
         }
         this.styleChangedFlag = false;
         this.invalidateDisplayListFlag = false;
      }
      
      private function validateTransformMatrix() : void
      {
         var mirrorMatrix:Matrix = null;
         var defaultMatrix:Matrix = null;
         if(this.mirror)
         {
            mirrorMatrix = this.transform.matrix;
            mirrorMatrix.a = -1;
            mirrorMatrix.tx = this._x + width;
            transform.matrix = mirrorMatrix;
         }
         else
         {
            defaultMatrix = new Matrix();
            defaultMatrix.tx = this._x;
            defaultMatrix.ty = y;
            transform.matrix = defaultMatrix;
         }
      }
      
      public function getTextStyles() : TextFormat
      {
         var textFormat:TextFormat = new TextFormat();
         var textAlign:String = this.getStyle("textAlign");
         if(textAlign == "start")
         {
            textAlign = direction == "ltr" ? TextFormatAlign.LEFT : TextFormatAlign.RIGHT;
         }
         else if(textAlign == "end")
         {
            textAlign = direction == "ltr" ? TextFormatAlign.RIGHT : TextFormatAlign.LEFT;
         }
         textFormat.align = textAlign;
         textFormat.bold = this.getStyle("fontWeight") == "bold";
         if(this.enabled)
         {
            if(this.explicitColor == StyleManager.NOT_A_COLOR)
            {
               textFormat.color = this.getStyle("color");
            }
            else
            {
               textFormat.color = this.explicitColor;
            }
         }
         else
         {
            textFormat.color = this.getStyle("disabledColor");
         }
         textFormat.font = StringUtil.trimArrayElements(this.getStyle("fontFamily"),",");
         textFormat.indent = this.getStyle("textIndent");
         textFormat.italic = this.getStyle("fontStyle") == "italic";
         var kerning:* = this.getStyle("kerning");
         if(kerning == "auto" || kerning == "on")
         {
            kerning = true;
         }
         else if(kerning == "default" || kerning == "off")
         {
            kerning = false;
         }
         textFormat.kerning = kerning;
         textFormat.leading = this.getStyle("leading");
         textFormat.leftMargin = this.ignorePadding ? 0 : this.getStyle("paddingLeft");
         textFormat.letterSpacing = this.getStyle("letterSpacing");
         textFormat.rightMargin = this.ignorePadding ? 0 : this.getStyle("paddingRight");
         textFormat.size = this.getStyle("fontSize");
         textFormat.underline = this.getStyle("textDecoration") == "underline";
         this.cachedTextFormat = textFormat;
         return textFormat;
      }
      
      public function setColor(color:uint) : void
      {
         this.explicitColor = color;
         this.styleChangedFlag = true;
         this.invalidateDisplayListFlag = true;
         this.validateNow();
      }
      
      public function invalidateSize() : void
      {
         this.invalidateDisplayListFlag = true;
      }
      
      public function invalidateDisplayList() : void
      {
         this.invalidateDisplayListFlag = true;
      }
      
      public function invalidateProperties() : void
      {
      }
      
      public function truncateToFit(truncationIndicator:String = null) : Boolean
      {
         var s:String = null;
         if(!truncationIndicator)
         {
            truncationIndicator = truncationIndicatorResource;
         }
         this.validateNow();
         var originalText:String = super.text;
         this.untruncatedText = originalText;
         var w:Number = width;
         if(originalText != "" && textWidth + TEXT_WIDTH_PADDING > w + 1e-14)
         {
            s = super.text = originalText;
            originalText.slice(0,Math.floor(w / (textWidth + TEXT_WIDTH_PADDING) * originalText.length));
            while(s.length > 1 && textWidth + TEXT_WIDTH_PADDING > w)
            {
               s = s.slice(0,-1);
               super.text = s + truncationIndicator;
            }
            return true;
         }
         return false;
      }
      
      private function changeHandler(event:Event) : void
      {
         this.explicitHTMLText = null;
      }
      
      private function textFieldStyleChangeHandler(event:Event) : void
      {
         if(this.explicitHTMLText != null)
         {
            super.htmlText = this.explicitHTMLText;
         }
      }
      
      private function resourceManager_changeHandler(event:Event) : void
      {
         truncationIndicatorResource = this.resourceManager.getString("core","truncationIndicator");
         if(this.untruncatedText != null)
         {
            super.text = this.untruncatedText;
            this.truncateToFit();
         }
      }
      
      public function owns(child:DisplayObject) : Boolean
      {
         return child == this;
      }
      
      public function get owner() : DisplayObjectContainer
      {
         return Boolean(this._owner) ? this._owner : this.parent;
      }
      
      public function set owner(value:DisplayObjectContainer) : void
      {
         this._owner = value;
      }
      
      private function creatingSystemManager() : ISystemManager
      {
         return this.moduleFactory != null && this.moduleFactory is ISystemManager ? ISystemManager(this.moduleFactory) : this.systemManager;
      }
      
      private function getEmbeddedFont(fontName:String, bold:Boolean, italic:Boolean) : EmbeddedFont
      {
         if(Boolean(this.cachedEmbeddedFont))
         {
            if(this.cachedEmbeddedFont.fontName == fontName && this.cachedEmbeddedFont.fontStyle == embeddedFontRegistry.getFontStyle(bold,italic))
            {
               return this.cachedEmbeddedFont;
            }
         }
         this.cachedEmbeddedFont = new EmbeddedFont(fontName,bold,italic);
         return this.cachedEmbeddedFont;
      }
      
      public function replayAutomatableEvent(event:Event) : Boolean
      {
         if(Boolean(this.automationDelegate))
         {
            return this.automationDelegate.replayAutomatableEvent(event);
         }
         return false;
      }
      
      public function createAutomationIDPart(child:IAutomationObject) : Object
      {
         return null;
      }
      
      public function createAutomationIDPartWithRequiredProperties(child:IAutomationObject, properties:Array) : Object
      {
         return null;
      }
      
      public function resolveAutomationIDPart(criteria:Object) : Array
      {
         return [];
      }
      
      public function getAutomationChildAt(index:int) : IAutomationObject
      {
         return null;
      }
      
      public function getAutomationChildren() : Array
      {
         return null;
      }
      
      public function get numAutomationChildren() : int
      {
         return 0;
      }
      
      public function get showInAutomationHierarchy() : Boolean
      {
         return true;
      }
      
      public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      public function get automationTabularData() : Object
      {
         return null;
      }
   }
}


package spark.components
{
   import flash.display.DisplayObject;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.ITextExporter;
   import flashx.textLayout.conversion.ITextImporter;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.DamageEvent;
   import flashx.textLayout.factory.StringTextLineFactory;
   import flashx.textLayout.factory.TextFlowTextLineFactory;
   import flashx.textLayout.factory.TextLineFactoryBase;
   import flashx.textLayout.factory.TruncationOptions;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import spark.components.supportClasses.TextBase;
   import spark.core.CSSTextLayoutFormat;
   import spark.utils.MaskUtil;
   import spark.utils.TextUtil;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("RichText.png")]
   [DefaultProperty("content")]
   [Style(name="columnWidth",type="Object",inherit="no")]
   [Style(name="columnGap",type="Number",format="Length",inherit="no")]
   [Style(name="columnCount",type="Object",inherit="no")]
   [Style(name="wordSpacing",type="Object",inherit="yes")]
   [Style(name="whiteSpaceCollapse",type="String",enumeration="collapse,preserve",inherit="yes")]
   [Style(name="textRotation",type="String",enumeration="auto,rotate0,rotate90,rotate180,rotate270",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes",minValue="0.0")]
   [Style(name="tabStops",type="String",inherit="yes")]
   [Style(name="paragraphStartIndent",type="Number",format="length",inherit="yes")]
   [Style(name="paragraphSpaceBefore",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphSpaceAfter",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="paragraphEndIndent",type="Number",format="length",inherit="yes",minValue="0.0")]
   [Style(name="listStyleType",type="String",enumeration="upperAlpha,lowerAlpha,upperRoman,lowerRoman,none,disc,circle,square,box,check,diamond,hyphen,arabicIndic,bengali,decimal,decimalLeadingZero,devanagari,gujarati,gurmukhi,kannada,persian,thai,urdu,cjkEarthlyBranch,cjkHeavenlyStem,hangul,hangulConstant,hiragana,hiraganaIroha,katakana,katakanaIroha,lowerGreek,lowerLatin,upperGreek,upperLatin",inherit="yes")]
   [Style(name="listStylePosition",type="String",enumeration="inside,outside",inherit="yes")]
   [Style(name="listAutoPadding",type="Number",format="length",inherit="yes",minValue="-1000",maxValue="1000")]
   [Style(name="leadingModel",type="String",enumeration="auto,romanUp,ideographicTopUp,ideographicCenterUp,ideographicTopDown,ideographicCenterDown,ascentDescentUp,box",inherit="yes")]
   [Style(name="firstBaselineOffset",type="Object",inherit="yes")]
   [Style(name="clearFloats",type="String",enumeration="start,end,left,right,both,none",inherit="yes")]
   [Style(name="breakOpportunity",type="String",enumeration="auto,all,any,none",inherit="yes")]
   [Style(name="blockProgression",type="String",enumeration="tb,rl",inherit="yes")]
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom,justify",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="lineBreak",type="String",enumeration="toFit,explicit",inherit="no")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   public class RichText extends TextBase
   {
      
      private static var staticStringFactory:StringTextLineFactory;
      
      private static var staticTextFlowFactory:TextFlowTextLineFactory;
      
      private static var staticPlainTextImporter:ITextImporter;
      
      private static var staticPlainTextExporter:ITextExporter;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var classInitialized:Boolean = false;
      
      private var hostFormat:ITextLayoutFormat;
      
      private var lastGeneration:uint = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var embeddedFontContext:IFlexModuleFactory;
      
      private var factory:TextLineFactoryBase;
      
      private var ignoreDamageEvent:Boolean;
      
      [CollapseWhiteSpace]
      private var textChanged:Boolean = false;
      
      private var source:String = "";
      
      protected var _content:Object;
      
      private var contentChanged:Boolean = false;
      
      private var maskChanged:Boolean;
      
      private var _maskType:String = "clip";
      
      private var maskTypeChanged:Boolean;
      
      private var _luminosityInvert:Boolean = false;
      
      private var luminositySettingsChanged:Boolean;
      
      private var _luminosityClip:Boolean = false;
      
      private var _textFlow:TextFlow;
      
      private var textFlowChanged:Boolean = false;
      
      public function RichText()
      {
         super();
         initClass();
         this.text = "";
      }
      
      private static function initClass() : void
      {
         if(classInitialized)
         {
            return;
         }
         GlobalSettings.resourceStringFunction = TextUtil.getResourceString;
         GlobalSettings.resolveFontLookupFunction = TextUtil.resolveFontLookup;
         GlobalSettings.enableDefaultTabStops = !Configuration.playerEnablesArgoFeatures;
         staticStringFactory = new StringTextLineFactory();
         staticTextFlowFactory = new TextFlowTextLineFactory();
         staticPlainTextImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
         staticPlainTextExporter = TextConverter.getExporter(TextConverter.PLAIN_TEXT_FORMAT);
         classInitialized = true;
      }
      
      override public function get text() : String
      {
         if(_text == null)
         {
            if(this.contentChanged)
            {
               this._textFlow = this.createTextFlowFromContent(this._content);
               this.lastGeneration = this._textFlow.generation;
            }
            _text = staticPlainTextExporter.export(this._textFlow,ConversionType.STRING_TYPE) as String;
         }
         return _text;
      }
      
      override public function set text(value:String) : void
      {
         if(value == null)
         {
            value = "";
         }
         if(this.source == "text" && value == _text)
         {
            return;
         }
         _text = value;
         this.textChanged = true;
         this.source = "text";
         this.textFlowChanged = false;
         this.contentChanged = false;
         this.removeDamageHandler();
         this._textFlow = null;
         this._content = null;
         this.factory = staticStringFactory;
         invalidateTextLines();
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [RichTextContent]
      public function get content() : Object
      {
         return this.textFlow;
      }
      
      public function set content(value:Object) : void
      {
         if(value == null)
         {
            this.text = "";
            return;
         }
         if(value == this._content)
         {
            return;
         }
         this._content = value;
         this.contentChanged = true;
         this.source = "content";
         this.textChanged = false;
         this.textFlowChanged = false;
         this.removeDamageHandler();
         _text = null;
         this._textFlow = null;
         this.factory = staticTextFlowFactory;
         invalidateTextLines();
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function set mask(value:DisplayObject) : void
      {
         if(super.mask == value)
         {
            return;
         }
         var oldMask:UIComponent = super.mask as UIComponent;
         super.mask = value;
         if(Boolean(oldMask) && oldMask.$parent === this)
         {
            if(oldMask.parent is UIComponent)
            {
               UIComponent(oldMask.parent).childRemoved(oldMask);
            }
            oldMask.$parent.removeChild(oldMask);
         }
         this.maskChanged = true;
         this.maskTypeChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(defaultValue="clip",enumeration="clip,alpha,luminosity")]
      public function get maskType() : String
      {
         return this._maskType;
      }
      
      public function set maskType(value:String) : void
      {
         if(this._maskType == value)
         {
            return;
         }
         this._maskType = value;
         this.maskTypeChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(defaultValue="false")]
      public function get luminosityInvert() : Boolean
      {
         return this._luminosityInvert;
      }
      
      public function set luminosityInvert(value:Boolean) : void
      {
         if(this._luminosityInvert == value)
         {
            return;
         }
         this._luminosityInvert = value;
         this.luminositySettingsChanged = true;
      }
      
      [Inspectable(defaultValue="false")]
      public function get luminosityClip() : Boolean
      {
         return this._luminosityClip;
      }
      
      public function set luminosityClip(value:Boolean) : void
      {
         if(this._luminosityClip == value)
         {
            return;
         }
         this._luminosityClip = value;
         this.luminositySettingsChanged = true;
      }
      
      public function get textFlow() : TextFlow
      {
         if(!this._textFlow)
         {
            if(this._content != null)
            {
               this._textFlow = this.createTextFlowFromContent(this._content);
            }
            else
            {
               this._textFlow = staticPlainTextImporter.importToFlow(_text);
            }
            this.lastGeneration = Boolean(this._textFlow) ? uint(this._textFlow.generation) : 0;
         }
         this._textFlow.addEventListener(DamageEvent.DAMAGE,this.textFlow_damageHandler);
         if(Boolean(this._textFlow.flowComposer))
         {
            this._textFlow.flowComposer.swfContext = ISWFContext(getEmbeddedFontContext());
         }
         return this._textFlow;
      }
      
      public function set textFlow(value:TextFlow) : void
      {
         if(value == null)
         {
            this.text = "";
            return;
         }
         if(value == this._textFlow)
         {
            return;
         }
         this.removeDamageHandler();
         this._textFlow = value;
         this.textFlowChanged = true;
         this.source = "textFlow";
         this.textChanged = false;
         this.contentChanged = false;
         _text = null;
         this._content = null;
         this.factory = staticTextFlowFactory;
         invalidateTextLines();
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.textChanged)
         {
            if(_text.indexOf("\n") != -1 || _text.indexOf("\r") != -1)
            {
               this._textFlow = staticPlainTextImporter.importToFlow(_text);
               this.factory = staticTextFlowFactory;
            }
            this.textChanged = false;
         }
         else if(this.textFlowChanged)
         {
            this.textFlowChanged = false;
         }
         else if(this.contentChanged)
         {
            this._textFlow = this.createTextFlowFromContent(this._content);
            this.contentChanged = false;
         }
         this.lastGeneration = Boolean(this._textFlow) ? uint(this._textFlow.generation) : 0;
         if(!this.hostFormat)
         {
            this.hostFormat = new CSSTextLayoutFormat(this);
         }
         if(Boolean(this._textFlow))
         {
            this._textFlow.hostFormat = this.hostFormat;
            this._textFlow.addEventListener(DamageEvent.DAMAGE,this.textFlow_damageHandler);
         }
         if(this.maskChanged)
         {
            if(Boolean(mask) && !mask.parent)
            {
               addChild(mask);
               MaskUtil.applyMask(mask,null);
            }
            this.maskChanged = false;
         }
         if(this.luminositySettingsChanged)
         {
            MaskUtil.applyLuminositySettings(mask,this._maskType,this._luminosityInvert,this._luminosityClip);
            this.luminositySettingsChanged = false;
         }
         if(this.maskTypeChanged)
         {
            MaskUtil.applyMaskType(mask,this._maskType,this._luminosityInvert,this._luminosityClip,this);
            this.maskTypeChanged = false;
         }
      }
      
      override public function stylesInitialized() : void
      {
         super.stylesInitialized();
         this.hostFormat = null;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.hostFormat = null;
         invalidateTextLines();
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(!isNaN(_composeHeight) && unscaledHeight != _composeHeight)
         {
            invalidateTextLines();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function composeTextLines(width:Number = NaN, height:Number = NaN) : Boolean
      {
         var bp:String = null;
         if(isNaN(width) && !isNaN(explicitMaxWidth))
         {
            width = Number(explicitMaxWidth);
         }
         super.composeTextLines(width,height);
         this.ignoreDamageEvent = true;
         bounds.x = 0;
         bounds.y = 0;
         bounds.width = width;
         bounds.height = height;
         removeTextLines();
         releaseTextLines();
         this.createTextLines();
         if(maxDisplayedLines != 0 && !isTruncated && getStyle("lineBreak") == "toFit")
         {
            bp = getStyle("blockProgression");
            if(isNaN(width) && bp == "tb" || isNaN(height) && bp != "tb")
            {
               textLines.length = 0;
               this.createTextLines();
            }
         }
         addTextLines();
         isOverset = isTextOverset(width,height);
         invalidateCompose = false;
         this.ignoreDamageEvent = false;
         return true;
      }
      
      private function createTextFlowFromContent(content:Object) : TextFlow
      {
         var textFlow:TextFlow = null;
         if(content is TextFlow)
         {
            textFlow = content as TextFlow;
         }
         else if(content is Array)
         {
            textFlow = new TextFlow();
            textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
            textFlow.mxmlChildren = content as Array;
            textFlow.whiteSpaceCollapse = undefined;
         }
         else
         {
            textFlow = new TextFlow();
            textFlow.whiteSpaceCollapse = getStyle("whiteSpaceCollapse");
            textFlow.mxmlChildren = [content];
            textFlow.whiteSpaceCollapse = undefined;
         }
         return textFlow;
      }
      
      private function createTextLines() : void
      {
         var truncationOptions:TruncationOptions = null;
         textLines.length = 0;
         this.factory.compositionBounds = bounds;
         if(maxDisplayedLines != 0)
         {
            truncationOptions = new TruncationOptions();
            truncationOptions.lineCountLimit = maxDisplayedLines;
            truncationOptions.truncationIndicator = TextBase.truncationIndicatorResource;
         }
         this.factory.truncationOptions = truncationOptions;
         this.embeddedFontContext = getEmbeddedFontContext();
         if(this.factory is StringTextLineFactory)
         {
            staticStringFactory.text = _text;
            staticStringFactory.textFlowFormat = this.hostFormat;
            staticStringFactory.swfContext = ISWFContext(this.embeddedFontContext);
            staticStringFactory.createTextLines(this.addTextLine);
         }
         else if(this.factory is TextFlowTextLineFactory)
         {
            if(Boolean(this._textFlow) && Boolean(this._textFlow.flowComposer))
            {
               this._textFlow.flowComposer.swfContext = ISWFContext(this.embeddedFontContext);
            }
            staticTextFlowFactory.swfContext = ISWFContext(this.embeddedFontContext);
            staticTextFlowFactory.createTextLines(this.addTextLine,this._textFlow);
         }
         bounds = this.factory.getContentBounds();
         setIsTruncated(this.factory.isTruncated);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createEmptyTextLine(height:Number = NaN) : void
      {
         textLines.length = 0;
         bounds.x = 0;
         bounds.y = 0;
         bounds.width = Boolean(width) ? Number(width) : NaN;
         bounds.height = height;
         staticStringFactory.compositionBounds = bounds;
         staticStringFactory.truncationOptions = null;
         staticStringFactory.text = "";
         staticStringFactory.textFlowFormat = this.hostFormat;
         staticStringFactory.createTextLines(this.addTextLine);
      }
      
      private function addTextLine(textLine:DisplayObject) : void
      {
         textLines.push(textLine);
      }
      
      private function removeDamageHandler() : void
      {
         if(this._textFlow != null)
         {
            this._textFlow.removeEventListener(DamageEvent.DAMAGE,this.textFlow_damageHandler);
         }
      }
      
      private function textFlow_damageHandler(event:DamageEvent) : void
      {
         if(this.ignoreDamageEvent || this._textFlow.generation == this.lastGeneration)
         {
            return;
         }
         this.lastGeneration = this._textFlow.generation;
         _text = null;
         this._content = null;
         this.factory = staticTextFlowFactory;
         invalidateTextLines();
         invalidateSize();
         invalidateDisplayList();
      }
   }
}


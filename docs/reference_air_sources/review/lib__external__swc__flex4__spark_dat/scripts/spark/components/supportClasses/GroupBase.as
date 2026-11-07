package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.GestureEvent;
   import flash.events.MouseEvent;
   import flash.events.PressAndTapGestureEvent;
   import flash.events.TouchEvent;
   import flash.events.TransformGestureEvent;
   import flash.filters.ShaderFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.shaderClasses.LuminosityMaskShader;
   import spark.components.ResizeMode;
   import spark.core.IViewport;
   import spark.core.MaskType;
   import spark.events.DisplayLayerObjectExistenceEvent;
   import spark.layouts.BasicLayout;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.utils.FTETextUtil;
   import spark.utils.MaskUtil;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Style(name="touchDelay",type="Number",format="Time",inherit="yes",minValue="0.0")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="downColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="disabledAlpha",type="Number",inherit="no",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark, mobile",minValue="0.0",maxValue="1.0")]
   [Style(name="chromeColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="unfocusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="inactiveTextSelectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="focusedTextSelectionColor",type="uint",format="Color",inherit="yes")]
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
   public class GroupBase extends UIComponent implements IViewport
   {
      
      private var _explicitAlpha:Number = 1;
      
      private var _explicitMouseChildren:Boolean = true;
      
      private var _explicitMouseEnabled:Boolean = true;
      
      private var _layout:LayoutBase;
      
      private var _layoutProperties:Object = null;
      
      private var layoutInvalidateSizeFlag:Boolean = false;
      
      private var layoutInvalidateDisplayListFlag:Boolean = false;
      
      private var clipAndEnableScrollingExplicitlySet:Boolean = false;
      
      private var _scrollRectSet:Boolean = false;
      
      private var _autoLayout:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _overlay:DisplayLayer;
      
      private var _resizeMode:String = "noScale";
      
      private var _mouseEnabledWhereTransparent:Boolean = true;
      
      private var mouseEventReferenceCount:int;
      
      private var _hasMouseListeners:Boolean = false;
      
      private var _contentWidth:Number = 0;
      
      private var _contentHeight:Number = 0;
      
      private var _focusPane:Sprite;
      
      private var _mask:DisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var maskChanged:Boolean;
      
      private var _maskType:String = "clip";
      
      private var maskTypeChanged:Boolean;
      
      private var originalMaskFilters:Array;
      
      private var _luminosityInvert:Boolean = false;
      
      private var luminositySettingsChanged:Boolean;
      
      private var _luminosityClip:Boolean = false;
      
      public function GroupBase()
      {
         super();
         showInAutomationHierarchy = false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function sortOnLayer(a:Vector.<IVisualElement>) : void
      {
         var tmp:IVisualElement = null;
         var j:int = 0;
         var len:Number = a.length;
         if(len <= 1)
         {
            return;
         }
         for(var i:int = 1; i < len; i++)
         {
            for(j = i; j > 0; j--)
            {
               if(a[j].depth >= a[j - 1].depth)
               {
                  break;
               }
               tmp = a[j];
               a[j] = a[j - 1];
               a[j - 1] = tmp;
            }
         }
      }
      
      override public function set alpha(value:Number) : void
      {
         if(enabled)
         {
            super.alpha = value;
         }
         this._explicitAlpha = value;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return FTETextUtil.calculateFontBaseline(this,height,moduleFactory);
      }
      
      override public function set mouseChildren(value:Boolean) : void
      {
         if(enabled)
         {
            super.mouseChildren = value;
         }
         this._explicitMouseChildren = value;
      }
      
      override public function set mouseEnabled(value:Boolean) : void
      {
         if(enabled)
         {
            super.mouseEnabled = value;
         }
         this._explicitMouseEnabled = value;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         var disabledAlpha:Number = NaN;
         super.enabled = value;
         super.mouseChildren = value ? this._explicitMouseChildren : false;
         super.mouseEnabled = value ? this._explicitMouseEnabled : false;
         if(value)
         {
            super.alpha = this._explicitAlpha;
         }
         else
         {
            disabledAlpha = Number(getStyle("disabledAlpha"));
            if(!isNaN(disabledAlpha))
            {
               super.alpha = disabledAlpha;
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get layout() : LayoutBase
      {
         return this._layout;
      }
      
      public function set layout(value:LayoutBase) : void
      {
         if(this._layout == value)
         {
            return;
         }
         if(Boolean(this._layout))
         {
            this._layout.target = null;
            this._layout.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.redispatchLayoutEvent);
            if(this.clipAndEnableScrollingExplicitlySet)
            {
               this._layoutProperties = {"clipAndEnableScrolling":this._layout.clipAndEnableScrolling};
            }
         }
         this._layout = value;
         if(Boolean(this._layout))
         {
            this._layout.target = this;
            this._layout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.redispatchLayoutEvent);
            if(Boolean(this._layoutProperties))
            {
               if(this._layoutProperties.clipAndEnableScrolling !== undefined)
               {
                  value.clipAndEnableScrolling = this._layoutProperties.clipAndEnableScrolling;
               }
               if(this._layoutProperties.verticalScrollPosition !== undefined)
               {
                  value.verticalScrollPosition = this._layoutProperties.verticalScrollPosition;
               }
               if(this._layoutProperties.horizontalScrollPosition !== undefined)
               {
                  value.horizontalScrollPosition = this._layoutProperties.horizontalScrollPosition;
               }
               this._layoutProperties = null;
            }
         }
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      private function redispatchLayoutEvent(event:Event) : void
      {
         var pce:PropertyChangeEvent = event as PropertyChangeEvent;
         if(Boolean(pce))
         {
            switch(pce.property)
            {
               case "verticalScrollPosition":
               case "horizontalScrollPosition":
                  dispatchEvent(event);
            }
         }
      }
      
      [Inspectable(minValue="0.0")]
      [Bindable(event="propertyChange")]
      public function get horizontalScrollPosition() : Number
      {
         if(Boolean(this._layout))
         {
            return this._layout.horizontalScrollPosition;
         }
         if(Boolean(this._layoutProperties) && this._layoutProperties.horizontalScrollPosition !== undefined)
         {
            return this._layoutProperties.horizontalScrollPosition;
         }
         return 0;
      }
      
      private function set _754184102horizontalScrollPosition(value:Number) : void
      {
         if(Boolean(this._layout))
         {
            this._layout.horizontalScrollPosition = value;
         }
         else if(Boolean(this._layoutProperties))
         {
            this._layoutProperties.horizontalScrollPosition = value;
         }
         else
         {
            this._layoutProperties = {"horizontalScrollPosition":value};
         }
      }
      
      [Inspectable(minValue="0.0")]
      [Bindable(event="propertyChange")]
      public function get verticalScrollPosition() : Number
      {
         if(Boolean(this._layout))
         {
            return this._layout.verticalScrollPosition;
         }
         if(Boolean(this._layoutProperties) && this._layoutProperties.verticalScrollPosition !== undefined)
         {
            return this._layoutProperties.verticalScrollPosition;
         }
         return 0;
      }
      
      private function set _1010846676verticalScrollPosition(value:Number) : void
      {
         if(Boolean(this._layout))
         {
            this._layout.verticalScrollPosition = value;
         }
         else if(Boolean(this._layoutProperties))
         {
            this._layoutProperties.verticalScrollPosition = value;
         }
         else
         {
            this._layoutProperties = {"verticalScrollPosition":value};
         }
      }
      
      public function get clipAndEnableScrolling() : Boolean
      {
         if(Boolean(this._layout))
         {
            return this._layout.clipAndEnableScrolling;
         }
         if(Boolean(this._layoutProperties) && this._layoutProperties.clipAndEnableScrolling !== undefined)
         {
            return this._layoutProperties.clipAndEnableScrolling;
         }
         return false;
      }
      
      public function set clipAndEnableScrolling(value:Boolean) : void
      {
         this.clipAndEnableScrollingExplicitlySet = true;
         if(Boolean(this._layout))
         {
            this._layout.clipAndEnableScrolling = value;
         }
         else if(Boolean(this._layoutProperties))
         {
            this._layoutProperties.clipAndEnableScrolling = value;
         }
         else
         {
            this._layoutProperties = {"clipAndEnableScrolling":value};
         }
         this.invalidateSize();
      }
      
      override public function get scrollRect() : Rectangle
      {
         return !this._scrollRectSet ? null : super.scrollRect;
      }
      
      override public function set scrollRect(value:Rectangle) : void
      {
         if(!this._scrollRectSet && !value)
         {
            return;
         }
         this._scrollRectSet = true;
         super.scrollRect = value;
      }
      
      [Inspectable(defaultValue="true")]
      public function get autoLayout() : Boolean
      {
         return this._autoLayout;
      }
      
      public function set autoLayout(value:Boolean) : void
      {
         if(this._autoLayout == value)
         {
            return;
         }
         this._autoLayout = value;
         if(value)
         {
            this.invalidateSize();
            this.invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get overlay() : DisplayLayer
      {
         if(!this._overlay)
         {
            this._overlay = new DisplayLayer();
            this._overlay.addEventListener(DisplayLayerObjectExistenceEvent.OBJECT_ADD,this.overlay_objectAdd);
            this._overlay.addEventListener(DisplayLayerObjectExistenceEvent.OBJECT_REMOVE,this.overlay_objectRemove);
            invalidateProperties();
         }
         return this._overlay;
      }
      
      private function overlay_objectAdd(event:DisplayLayerObjectExistenceEvent) : void
      {
         super.addChildAt(event.object,event.index + numChildren - this._overlay.numDisplayObjects + 1);
      }
      
      private function overlay_objectRemove(event:DisplayLayerObjectExistenceEvent) : void
      {
         super.removeChild(event.object);
         if(this._overlay.numDisplayObjects == 1)
         {
            invalidateProperties();
         }
      }
      
      private function destroyOverlay() : void
      {
         this._overlay.removeEventListener(DisplayLayerObjectExistenceEvent.OBJECT_ADD,this.overlay_objectAdd);
         this._overlay.removeEventListener(DisplayLayerObjectExistenceEvent.OBJECT_REMOVE,this.overlay_objectRemove);
         this._overlay = null;
      }
      
      [Inspectable(category="General",enumeration="noScale,scale",defaultValue="noScale")]
      public function get resizeMode() : String
      {
         return this._resizeMode;
      }
      
      public function set resizeMode(value:String) : void
      {
         if(this._resizeMode == value)
         {
            return;
         }
         if(this._resizeMode == ResizeMode.SCALE)
         {
            setStretchXY(1,1);
         }
         this._resizeMode = value;
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      public function get mouseEnabledWhereTransparent() : Boolean
      {
         return this._mouseEnabledWhereTransparent;
      }
      
      public function set mouseEnabledWhereTransparent(value:Boolean) : void
      {
         if(value == this._mouseEnabledWhereTransparent)
         {
            return;
         }
         this._mouseEnabledWhereTransparent = value;
         if(this._hasMouseListeners)
         {
            this.invalidateDisplayList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function drawBackground() : void
      {
         var tileSize:int = 0;
         var maxX:int = 0;
         var maxY:int = 0;
         var x:int = 0;
         var y:int = 0;
         var tileWidth:int = 0;
         var tileHeight:int = 0;
         if(!this._mouseEnabledWhereTransparent || !this._hasMouseListeners)
         {
            return;
         }
         var w:Number = this._resizeMode == ResizeMode.SCALE ? Number(measuredWidth) : Number(unscaledWidth);
         var h:Number = this._resizeMode == ResizeMode.SCALE ? Number(measuredHeight) : Number(unscaledHeight);
         if(isNaN(w) || isNaN(h))
         {
            return;
         }
         graphics.clear();
         graphics.beginFill(16777215,0);
         if(Boolean(this.layout) && this.layout.useVirtualLayout)
         {
            graphics.drawRect(this.horizontalScrollPosition,this.verticalScrollPosition,w,h);
         }
         else
         {
            tileSize = 4096;
            maxX = Math.round(Math.max(w,this.contentWidth));
            maxY = Math.round(Math.max(h,this.contentHeight));
            for(x = 0; x < maxX; x += tileSize)
            {
               for(y = 0; y < maxY; y += tileSize)
               {
                  tileWidth = Math.min(maxX - x,tileSize);
                  tileHeight = Math.min(maxY - y,tileSize);
                  graphics.drawRect(x,y,tileWidth,tileHeight);
               }
            }
         }
         graphics.endFill();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set hasMouseListeners(value:Boolean) : void
      {
         if(this._mouseEnabledWhereTransparent)
         {
            this.$invalidateDisplayList();
         }
         this._hasMouseListeners = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get hasMouseListeners() : Boolean
      {
         return this._hasMouseListeners;
      }
      
      override protected function canSkipMeasurement() : Boolean
      {
         return this._resizeMode == ResizeMode.SCALE ? false : Boolean(super.canSkipMeasurement());
      }
      
      override public function invalidateSize() : void
      {
         super.invalidateSize();
         this.layoutInvalidateSizeFlag = true;
      }
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         this.layoutInvalidateDisplayListFlag = true;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function childXYChanged() : void
      {
         if(this.autoLayout)
         {
            this.invalidateSize();
            this.invalidateDisplayList();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $invalidateSize() : void
      {
         super.invalidateSize();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.layout)
         {
            this.layout = new BasicLayout();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(this._overlay) && this._overlay.numDisplayObjects == 0)
         {
            this.destroyOverlay();
         }
      }
      
      override protected function measure() : void
      {
         var oldMeasuredWidth:Number = NaN;
         var oldMeasuredHeight:Number = NaN;
         if(Boolean(this._layout) && this.layoutInvalidateSizeFlag)
         {
            oldMeasuredWidth = Number(measuredWidth);
            oldMeasuredHeight = Number(measuredHeight);
            super.measure();
            this.layoutInvalidateSizeFlag = false;
            this._layout.measure();
            if(this.clipAndEnableScrolling || this.resizeMode == ResizeMode.SCALE)
            {
               measuredMinWidth = 0;
               measuredMinHeight = 0;
            }
            if(this._resizeMode == ResizeMode.SCALE && (measuredWidth != oldMeasuredWidth || measuredHeight != oldMeasuredHeight))
            {
               this.invalidateDisplayList();
            }
         }
      }
      
      override protected function validateMatrix() : void
      {
         var stretchX:Number = NaN;
         var stretchY:Number = NaN;
         if(this._resizeMode == ResizeMode.SCALE)
         {
            stretchX = 1;
            stretchY = 1;
            if(measuredWidth != 0)
            {
               stretchX = width / measuredWidth;
            }
            if(measuredHeight != 0)
            {
               stretchY = height / measuredHeight;
            }
            setStretchXY(stretchX,stretchY);
         }
         super.validateMatrix();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var shaderFilter:ShaderFilter = null;
         var shaderFilterIndex:int = 0;
         var len:int = 0;
         var luminosityMaskShader:LuminosityMaskShader = null;
         if(this._resizeMode == ResizeMode.SCALE)
         {
            unscaledWidth = Number(measuredWidth);
            unscaledHeight = Number(measuredHeight);
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.maskChanged)
         {
            this.maskChanged = false;
            if(Boolean(this._mask))
            {
               this.maskTypeChanged = true;
               if(!this._mask.parent)
               {
                  this.overlay.addDisplayObject(this._mask,OverlayDepth.MASK);
                  MaskUtil.applyMask(this._mask,null);
               }
            }
         }
         if(this.luminositySettingsChanged)
         {
            this.luminositySettingsChanged = false;
            if(Boolean(this._mask) && Boolean(this._maskType == MaskType.LUMINOSITY) && this._mask.filters.length > 0)
            {
               len = int(this._mask.filters.length);
               for(shaderFilterIndex = 0; shaderFilterIndex < len; shaderFilterIndex++)
               {
                  if(this._mask.filters[shaderFilterIndex] is ShaderFilter && ShaderFilter(this._mask.filters[shaderFilterIndex]).shader is LuminosityMaskShader)
                  {
                     shaderFilter = this._mask.filters[shaderFilterIndex];
                     break;
                  }
               }
               if(Boolean(shaderFilter) && shaderFilter.shader is LuminosityMaskShader)
               {
                  LuminosityMaskShader(shaderFilter.shader).mode = this.calculateLuminositySettings();
                  this._mask.filters[shaderFilterIndex] = shaderFilter;
                  this._mask.filters = this._mask.filters;
               }
            }
         }
         if(this.maskTypeChanged)
         {
            this.maskTypeChanged = false;
            if(Boolean(this._mask))
            {
               if(this._maskType == MaskType.CLIP)
               {
                  this._mask.cacheAsBitmap = false;
                  this.originalMaskFilters = this._mask.filters;
                  this._mask.filters = [];
               }
               else if(this._maskType == MaskType.ALPHA)
               {
                  this._mask.cacheAsBitmap = true;
                  cacheAsBitmap = true;
               }
               else if(this._maskType == MaskType.LUMINOSITY)
               {
                  this._mask.cacheAsBitmap = true;
                  cacheAsBitmap = true;
                  luminosityMaskShader = new LuminosityMaskShader();
                  luminosityMaskShader.mode = this.calculateLuminositySettings();
                  shaderFilter = new ShaderFilter(luminosityMaskShader);
                  this._mask.filters = [shaderFilter];
               }
            }
         }
         if(this.layoutInvalidateDisplayListFlag)
         {
            this.layoutInvalidateDisplayListFlag = false;
            if(this.autoLayout && Boolean(this._layout))
            {
               this._layout.updateDisplayList(unscaledWidth,unscaledHeight);
            }
            if(Boolean(this._layout))
            {
               this._layout.updateScrollRect(unscaledWidth,unscaledHeight);
            }
         }
      }
      
      private function calculateLuminositySettings() : int
      {
         var mode:int = 0;
         if(this.luminosityInvert)
         {
            mode += 1;
         }
         if(this.luminosityClip)
         {
            mode += 2;
         }
         return mode;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var disabledAlpha:Number = NaN;
         super.styleChanged(styleProp);
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(!enabled && (allStyles || styleProp == "disabledAlpha"))
         {
            disabledAlpha = Number(getStyle("disabledAlpha"));
            if(!isNaN(disabledAlpha))
            {
               super.alpha = disabledAlpha;
            }
         }
      }
      
      override public function globalToLocal(point:Point) : Point
      {
         var sX:Number = NaN;
         var sY:Number = NaN;
         var p:Point = null;
         if(this.resizeMode == ResizeMode.SCALE && _layoutFeatures != null)
         {
            sX = Number(_layoutFeatures.stretchX);
            sY = Number(_layoutFeatures.stretchY);
            _layoutFeatures.stretchX = 1;
            _layoutFeatures.stretchY = 1;
            applyComputedMatrix();
            p = super.globalToLocal(point);
            _layoutFeatures.stretchX = sX;
            _layoutFeatures.stretchY = sY;
            applyComputedMatrix();
            return p;
         }
         return super.globalToLocal(point);
      }
      
      override public function localToGlobal(point:Point) : Point
      {
         var sX:Number = NaN;
         var sY:Number = NaN;
         var p:Point = null;
         if(this.resizeMode == ResizeMode.SCALE && _layoutFeatures != null)
         {
            sX = Number(_layoutFeatures.stretchX);
            sY = Number(_layoutFeatures.stretchY);
            _layoutFeatures.stretchX = 1;
            _layoutFeatures.stretchY = 1;
            applyComputedMatrix();
            p = super.localToGlobal(point);
            _layoutFeatures.stretchX = sX;
            _layoutFeatures.stretchY = sY;
            applyComputedMatrix();
            return p;
         }
         return super.localToGlobal(point);
      }
      
      public function getHorizontalScrollPositionDelta(navigationUnit:uint) : Number
      {
         return Boolean(this.layout) ? this.layout.getHorizontalScrollPositionDelta(navigationUnit) : 0;
      }
      
      public function getVerticalScrollPositionDelta(navigationUnit:uint) : Number
      {
         return Boolean(this.layout) ? this.layout.getVerticalScrollPositionDelta(navigationUnit) : 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isElementVisible(elt:ILayoutElement) : Boolean
      {
         return Boolean(this.layout) && this.layout.isElementVisible(elt);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      private function setContentWidth(value:Number) : void
      {
         if(value == this._contentWidth)
         {
            return;
         }
         var oldValue:Number = this._contentWidth;
         this._contentWidth = value;
         dispatchPropertyChangeEvent("contentWidth",oldValue,value);
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get contentHeight() : Number
      {
         return this._contentHeight;
      }
      
      private function setContentHeight(value:Number) : void
      {
         if(value == this._contentHeight)
         {
            return;
         }
         var oldValue:Number = this._contentHeight;
         this._contentHeight = value;
         dispatchPropertyChangeEvent("contentHeight",oldValue,value);
      }
      
      public function setContentSize(width:Number, height:Number) : void
      {
         if(width == this._contentWidth && height == this._contentHeight)
         {
            return;
         }
         this.setContentWidth(width);
         this.setContentHeight(height);
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         switch(type)
         {
            case MouseEvent.CLICK:
            case MouseEvent.DOUBLE_CLICK:
            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_MOVE:
            case MouseEvent.MOUSE_OVER:
            case MouseEvent.MOUSE_OUT:
            case MouseEvent.ROLL_OUT:
            case MouseEvent.ROLL_OVER:
            case MouseEvent.MOUSE_UP:
            case MouseEvent.MOUSE_WHEEL:
            case TouchEvent.TOUCH_BEGIN:
            case TouchEvent.TOUCH_END:
            case TouchEvent.TOUCH_MOVE:
            case TouchEvent.TOUCH_OUT:
            case TouchEvent.TOUCH_OVER:
            case TouchEvent.TOUCH_ROLL_OUT:
            case TouchEvent.TOUCH_ROLL_OVER:
            case TouchEvent.TOUCH_TAP:
            case GestureEvent.GESTURE_TWO_FINGER_TAP:
            case PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP:
            case TransformGestureEvent.GESTURE_PAN:
            case TransformGestureEvent.GESTURE_ROTATE:
            case TransformGestureEvent.GESTURE_SWIPE:
            case TransformGestureEvent.GESTURE_ZOOM:
               if(this.mouseEventReferenceCount++ == 0)
               {
                  this.hasMouseListeners = true;
               }
         }
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         switch(type)
         {
            case MouseEvent.CLICK:
            case MouseEvent.DOUBLE_CLICK:
            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_MOVE:
            case MouseEvent.MOUSE_OVER:
            case MouseEvent.MOUSE_OUT:
            case MouseEvent.ROLL_OUT:
            case MouseEvent.ROLL_OVER:
            case MouseEvent.MOUSE_UP:
            case MouseEvent.MOUSE_WHEEL:
            case TouchEvent.TOUCH_BEGIN:
            case TouchEvent.TOUCH_END:
            case TouchEvent.TOUCH_MOVE:
            case TouchEvent.TOUCH_OUT:
            case TouchEvent.TOUCH_OVER:
            case TouchEvent.TOUCH_ROLL_OUT:
            case TouchEvent.TOUCH_ROLL_OVER:
            case TouchEvent.TOUCH_TAP:
            case GestureEvent.GESTURE_TWO_FINGER_TAP:
            case PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP:
            case TransformGestureEvent.GESTURE_PAN:
            case TransformGestureEvent.GESTURE_ROTATE:
            case TransformGestureEvent.GESTURE_SWIPE:
            case TransformGestureEvent.GESTURE_ZOOM:
               if(--this.mouseEventReferenceCount == 0)
               {
                  this.hasMouseListeners = false;
               }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function $removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
      }
      
      [Inspectable(environment="none")]
      override public function get focusPane() : Sprite
      {
         return this._focusPane;
      }
      
      override public function set focusPane(value:Sprite) : void
      {
         if(Boolean(value))
         {
            this.overlay.addDisplayObject(value,OverlayDepth.FOCUS_PANE);
            value.x = 0;
            value.y = 0;
            value.scrollRect = null;
            this._focusPane = value;
         }
         else
         {
            this.overlay.removeDisplayObject(this._focusPane);
            this._focusPane = null;
         }
      }
      
      public function get numElements() : int
      {
         return -1;
      }
      
      public function getElementAt(index:int) : IVisualElement
      {
         return null;
      }
      
      public function getVirtualElementAt(index:int, eltWidth:Number = NaN, eltHeight:Number = NaN) : IVisualElement
      {
         return this.getElementAt(index);
      }
      
      public function getElementIndex(element:IVisualElement) : int
      {
         return -1;
      }
      
      public function containsElement(element:IVisualElement) : Boolean
      {
         while(Boolean(element))
         {
            if(element == this)
            {
               return true;
            }
            if(!(element.parent is IVisualElement))
            {
               return false;
            }
            element = IVisualElement(element.parent);
         }
         return false;
      }
      
      [Inspectable(category="General")]
      override public function get mask() : DisplayObject
      {
         return this._mask;
      }
      
      override public function set mask(value:DisplayObject) : void
      {
         if(this._mask !== value)
         {
            if(Boolean(this._mask) && this._mask.parent === this)
            {
               this.overlay.removeDisplayObject(this._mask);
            }
            this._mask = value;
            this.maskChanged = true;
            this.invalidateDisplayList();
         }
         super.mask = value;
      }
      
      [Inspectable(category="General",enumeration="clip,alpha,luminosity",defaultValue="clip")]
      [Bindable("propertyChange")]
      public function get maskType() : String
      {
         return this._maskType;
      }
      
      public function set maskType(value:String) : void
      {
         if(this._maskType != value)
         {
            this._maskType = value;
            this.maskTypeChanged = true;
            this.invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
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
         this.invalidateDisplayList();
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="false")]
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
         this.invalidateDisplayList();
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         var _loc2_:Object = this.verticalScrollPosition;
         if(_loc2_ !== param1)
         {
            this._1010846676verticalScrollPosition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalScrollPosition",_loc2_,param1));
            }
         }
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         var _loc2_:Object = this.horizontalScrollPosition;
         if(_loc2_ !== param1)
         {
            this._754184102horizontalScrollPosition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalScrollPosition",_loc2_,param1));
            }
         }
      }
   }
}


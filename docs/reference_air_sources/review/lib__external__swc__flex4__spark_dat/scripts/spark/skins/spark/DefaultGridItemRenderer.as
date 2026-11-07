package spark.skins.spark
{
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import mx.core.DesignLayer;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIFTETextField;
   import mx.events.FlexEvent;
   import mx.events.ToolTipEvent;
   import mx.geom.TransformOffsets;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   import mx.styles.StyleProtoChain;
   import spark.components.Grid;
   import spark.components.gridClasses.GridColumn;
   import spark.components.gridClasses.GridItemRenderer;
   import spark.components.gridClasses.IGridItemRenderer;
   
   [Exclude(name="locale",kind="property")]
   [Exclude(name="direction",kind="property")]
   [Exclude(name="layoutDirection",kind="style")]
   [Exclude(name="layoutDirection",kind="property")]
   [Exclude(name="typographicCase",kind="style")]
   [Exclude(name="trackingRight",kind="style")]
   [Exclude(name="trackingLeft",kind="style")]
   [Exclude(name="textJustify",kind="style")]
   [Exclude(name="textAlpha",kind="style")]
   [Exclude(name="textAlignLast",kind="style")]
   [Exclude(name="renderingMode",kind="style")]
   [Exclude(name="lineThrough",kind="style")]
   [Exclude(name="lineHeight",kind="style")]
   [Exclude(name="ligatureLevel",kind="style")]
   [Exclude(name="leading",kind="style")]
   [Exclude(name="justificationStyle",kind="style")]
   [Exclude(name="justificationRule",kind="style")]
   [Exclude(name="fontLookup",kind="style")]
   [Exclude(name="dominantBaseline",kind="style")]
   [Exclude(name="digitWidth",kind="style")]
   [Exclude(name="digitCase",kind="style")]
   [Exclude(name="cffHinting",kind="style")]
   [Exclude(name="baselineShift",kind="style")]
   [Exclude(name="alignmentBaseline",kind="style")]
   [Exclude(name="verticalAlign",kind="style")]
   [Exclude(name="paddingTop",kind="style")]
   [Exclude(name="paddingBottom",kind="style")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes",minValue="0.0")]
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
   [Style(name="verticalAlign",type="String",enumeration="top,middle,bottom,justify",inherit="no")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no",minValue="0.0",maxValue="1000.0")]
   [Style(name="lineBreak",type="String",enumeration="toFit,explicit",inherit="no")]
   public class DefaultGridItemRenderer extends UIFTETextField implements IGridItemRenderer, IStyleClient
   {
      
      private static const LEFT_PADDING:Number = 5;
      
      private static const RIGHT_PADDING:Number = 5;
      
      private static const TOP_PADDING:Number = 4;
      
      private static const BOTTOM_PADDING:Number = 3;
      
      private var preferredSizeInvalid:Boolean = false;
      
      private var preferredWidth:Number;
      
      private var preferredHeight:Number;
      
      private var enableValidateNow:Boolean = true;
      
      private var inSetLayoutBoundsSize:Boolean = false;
      
      private var deferredSetStyles:Object = null;
      
      private var _column:GridColumn = null;
      
      private var _data:Object = null;
      
      private var _down:Boolean = false;
      
      private var _hovered:Boolean = false;
      
      private var _rowIndex:int = -1;
      
      private var _showsCaret:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _dragging:Boolean = false;
      
      private var _label:String = "";
      
      private var multilineSet:Boolean = false;
      
      private var wordWrapSet:Boolean = false;
      
      private var _styleDeclaration:CSSStyleDeclaration;
      
      public function DefaultGridItemRenderer()
      {
         super();
         autoSize = TextFieldAutoSize.NONE;
         inheritingStyles = StyleProtoChain.STYLE_UNINITIALIZED;
         nonInheritingStyles = StyleProtoChain.STYLE_UNINITIALIZED;
         addEventListener(ToolTipEvent.TOOL_TIP_SHOW,GridItemRenderer.toolTipShowHandler);
      }
      
      override public function set direction(value:String) : void
      {
         this.setStyle("direction",value);
      }
      
      override public function set locale(value:String) : void
      {
         this.setStyle("locale",value);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(!value && super.enabled)
         {
            this.setStyle("disabledColor",this.getStyle("color"));
         }
         super.enabled = value;
      }
      
      private function dispatchChangeEvent(type:String) : void
      {
         if(hasEventListener(type))
         {
            dispatchEvent(new Event(type));
         }
      }
      
      [Bindable("columnChanged")]
      public function get column() : GridColumn
      {
         return this._column;
      }
      
      public function set column(value:GridColumn) : void
      {
         if(this._column == value)
         {
            return;
         }
         this._column = value;
         this.dispatchChangeEvent("columnChanged");
      }
      
      public function get columnIndex() : int
      {
         return Boolean(this._column) ? this._column.columnIndex : -1;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         if(this._data == value)
         {
            return;
         }
         this._data = value;
         var eventType:String = "dataChange";
         if(hasEventListener(eventType))
         {
            dispatchEvent(new FlexEvent(eventType));
         }
      }
      
      [Bindable("downChanged")]
      public function get down() : Boolean
      {
         return this._down;
      }
      
      public function set down(value:Boolean) : void
      {
         if(this._down == value)
         {
            return;
         }
         this._down = value;
         this.dispatchChangeEvent("downChanged");
      }
      
      public function get grid() : Grid
      {
         return Boolean(this._column) ? this._column.grid : null;
      }
      
      [Bindable("hoveredChanged")]
      public function get hovered() : Boolean
      {
         return this._hovered;
      }
      
      public function set hovered(value:Boolean) : void
      {
         if(this._hovered == value)
         {
            return;
         }
         this._hovered = value;
         this.dispatchChangeEvent("hoveredChanged");
      }
      
      [Bindable("rowIndexChanged")]
      public function get rowIndex() : int
      {
         return this._rowIndex;
      }
      
      public function set rowIndex(value:int) : void
      {
         if(this._rowIndex == value)
         {
            return;
         }
         this._rowIndex = value;
         this.dispatchChangeEvent("rowIndexChanged");
      }
      
      [Bindable("showsCaretChanged")]
      public function get showsCaret() : Boolean
      {
         return this._showsCaret;
      }
      
      public function set showsCaret(value:Boolean) : void
      {
         if(this._showsCaret == value)
         {
            return;
         }
         this._showsCaret = value;
         this.dispatchChangeEvent("labelDisplayChanged");
      }
      
      [Bindable("selectedChanged")]
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this.dispatchChangeEvent("selectedChanged");
      }
      
      [Bindable("draggingChanged")]
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function set dragging(value:Boolean) : void
      {
         if(this._dragging == value)
         {
            return;
         }
         this._dragging = value;
         this.dispatchChangeEvent("draggingChanged");
      }
      
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         if(this._label == value)
         {
            return;
         }
         this._label = value;
         this.preferredSizeInvalid = true;
         this.dispatchChangeEvent("labelChanged");
      }
      
      override public function set moduleFactory(factory:IFlexModuleFactory) : void
      {
         var styleProp:String = null;
         super.moduleFactory = factory;
         if(Boolean(this.deferredSetStyles))
         {
            for(styleProp in this.deferredSetStyles)
            {
               StyleProtoChain.setStyle(this,styleProp,this.deferredSetStyles[styleProp]);
            }
            this.deferredSetStyles = null;
         }
      }
      
      override public function set multiline(value:Boolean) : void
      {
         super.multiline = value;
         this.multilineSet = true;
      }
      
      override public function set text(value:String) : void
      {
         this.enableValidateNow = false;
         super.text = value;
         this.preferredSizeInvalid = true;
         this.enableValidateNow = true;
      }
      
      override public function set wordWrap(value:Boolean) : void
      {
         super.wordWrap = value;
         this.wordWrapSet = true;
      }
      
      [Bindable(style="true")]
      override public function getStyle(styleProp:String) : *
      {
         if(!moduleFactory)
         {
            if(Boolean(this.deferredSetStyles) && this.deferredSetStyles[styleProp] !== undefined)
            {
               return this.deferredSetStyles[styleProp];
            }
         }
         return super.getStyle(styleProp);
      }
      
      override public function setStyle(styleProp:String, newValue:*) : void
      {
         if(Boolean(moduleFactory))
         {
            StyleProtoChain.setStyle(this,styleProp,newValue);
         }
         else
         {
            if(!this.deferredSetStyles)
            {
               this.deferredSetStyles = new Object();
            }
            this.deferredSetStyles[styleProp] = newValue;
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.preferredSizeInvalid = true;
      }
      
      private function updatePreferredSize() : void
      {
         var m:Matrix = null;
         if(!this.preferredSizeInvalid)
         {
            return;
         }
         if(Boolean(!this.wordWrapSet) && Boolean(this.column) && Boolean(this.column.grid))
         {
            super.wordWrap = this.column.grid.variableRowHeight;
         }
         if(!this.multilineSet && this.getStyle("lineBreak") == "explicit")
         {
            super.multiline = this._label.indexOf("\n") != -1;
         }
         this.text = this._label;
         super.validateNow();
         var paddedTextWidth:Number = isNaN(explicitWidth) ? textWidth + LEFT_PADDING + RIGHT_PADDING + TEXT_WIDTH_PADDING : Math.max(explicitWidth,4,LEFT_PADDING + RIGHT_PADDING + TEXT_WIDTH_PADDING);
         var paddedTextHeight:Number = isNaN(explicitHeight) ? textHeight + TOP_PADDING + BOTTOM_PADDING + TEXT_HEIGHT_PADDING : Math.max(explicitHeight,TOP_PADDING + BOTTOM_PADDING + TEXT_HEIGHT_PADDING);
         if(!stage || embedFonts)
         {
            this.preferredWidth = paddedTextWidth;
            this.preferredHeight = paddedTextHeight;
         }
         else
         {
            m = transform.concatenatedMatrix;
            this.preferredWidth = Math.abs(paddedTextWidth * m.a / m.d);
            this.preferredHeight = Math.abs(paddedTextHeight * m.a / m.d);
         }
         GridItemRenderer.initializeRendererToolTip(this);
         this.preferredSizeInvalid = false;
      }
      
      override public function validateNow() : void
      {
         if(!this.enableValidateNow || !parent)
         {
            return;
         }
         this.updatePreferredSize();
      }
      
      public function prepare(willBeRecycled:Boolean) : void
      {
      }
      
      public function discard(hasBeenRecycled:Boolean) : void
      {
         if(!this.multilineSet)
         {
            super.multiline = false;
         }
         if(!this.wordWrapSet)
         {
            super.wordWrap = false;
         }
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         if(!this.inSetLayoutBoundsSize)
         {
            explicitWidth = value;
            this.preferredSizeInvalid = true;
         }
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         if(!this.inSetLayoutBoundsSize)
         {
            explicitHeight = value;
            this.preferredSizeInvalid = true;
         }
      }
      
      public function get depth() : Number
      {
         return 0;
      }
      
      public function set depth(value:Number) : void
      {
      }
      
      public function get designLayer() : DesignLayer
      {
         return null;
      }
      
      public function set designLayer(value:DesignLayer) : void
      {
      }
      
      public function get postLayoutTransformOffsets() : TransformOffsets
      {
         return null;
      }
      
      public function set postLayoutTransformOffsets(value:TransformOffsets) : void
      {
      }
      
      public function get is3D() : Boolean
      {
         return false;
      }
      
      public function get left() : Object
      {
         return null;
      }
      
      public function set left(value:Object) : void
      {
      }
      
      public function get right() : Object
      {
         return null;
      }
      
      public function set right(value:Object) : void
      {
      }
      
      public function get top() : Object
      {
         return null;
      }
      
      public function set top(value:Object) : void
      {
      }
      
      public function get bottom() : Object
      {
         return null;
      }
      
      public function set bottom(value:Object) : void
      {
      }
      
      public function get horizontalCenter() : Object
      {
         return null;
      }
      
      public function set horizontalCenter(value:Object) : void
      {
      }
      
      public function get verticalCenter() : Object
      {
         return null;
      }
      
      public function set verticalCenter(value:Object) : void
      {
      }
      
      public function get baseline() : Object
      {
         return null;
      }
      
      public function set baseline(value:Object) : void
      {
      }
      
      public function getPreferredBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         this.updatePreferredSize();
         return this.preferredWidth;
      }
      
      public function getPreferredBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         this.updatePreferredSize();
         return this.preferredHeight;
      }
      
      public function getMinBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return minWidth;
      }
      
      public function getMinBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return minHeight;
      }
      
      public function getMaxBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return maxWidth;
      }
      
      public function getMaxBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return maxHeight;
      }
      
      public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         return x - LEFT_PADDING;
      }
      
      public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         return y - TOP_PADDING;
      }
      
      public function getLayoutBoundsWidth(postLayoutTransform:Boolean = true) : Number
      {
         return width + LEFT_PADDING + RIGHT_PADDING;
      }
      
      public function getLayoutBoundsHeight(postLayoutTransform:Boolean = true) : Number
      {
         return height + TOP_PADDING + BOTTOM_PADDING;
      }
      
      public function getLayoutBoundsX(postLayoutTransform:Boolean = true) : Number
      {
         return x - LEFT_PADDING;
      }
      
      public function getLayoutBoundsY(postLayoutTransform:Boolean = true) : Number
      {
         return y - TOP_PADDING;
      }
      
      public function setLayoutBoundsPosition(x:Number, y:Number, postLayoutTransform:Boolean = true) : void
      {
         move(x + LEFT_PADDING,y + TOP_PADDING);
      }
      
      public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         this.inSetLayoutBoundsSize = true;
         setActualSize(width - (LEFT_PADDING + RIGHT_PADDING),height - (TOP_PADDING + BOTTOM_PADDING));
         this.preferredSizeInvalid = true;
         this.inSetLayoutBoundsSize = false;
      }
      
      public function getLayoutMatrix() : Matrix
      {
         return null;
      }
      
      public function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean) : void
      {
      }
      
      public function get hasLayoutMatrix3D() : Boolean
      {
         return false;
      }
      
      public function getLayoutMatrix3D() : Matrix3D
      {
         return null;
      }
      
      public function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean) : void
      {
      }
      
      public function transformAround(transformCenter:Vector3D, scale:Vector3D = null, rotation:Vector3D = null, translation:Vector3D = null, postLayoutScale:Vector3D = null, postLayoutRotation:Vector3D = null, postLayoutTranslation:Vector3D = null, invalidateLayout:Boolean = true) : void
      {
      }
      
      public function get layoutDirection() : String
      {
         return this.getStyle("layoutDirection");
      }
      
      public function set layoutDirection(value:String) : void
      {
      }
      
      public function invalidateLayoutDirection() : void
      {
      }
      
      public function getClassStyleDeclarations() : Array
      {
         var styleDeclaration:CSSStyleDeclaration = null;
         var className:String = getQualifiedClassName(this).replace("::",".");
         var styleDeclarations:Array = [];
         while(className != "mx.core.UIFTETextField" && className != "mx.core.UITextField")
         {
            styleDeclaration = styleManager.getMergedStyleDeclaration(className);
            if(Boolean(styleDeclaration))
            {
               styleDeclarations.unshift(styleDeclaration);
            }
            try
            {
               className = getQualifiedSuperclassName(getDefinitionByName(className)).replace("::",".");
            }
            catch(e:ReferenceError)
            {
               break;
            }
         }
         return styleDeclarations;
      }
      
      public function initProtoChain() : void
      {
         var styleNames:Array = null;
         var c:int = 0;
         var inheritChain:Object = null;
         var typeSelector:CSSStyleDeclaration = null;
         var classSelector:CSSStyleDeclaration = null;
         styleChangedFlag = true;
         var classSelectors:Array = [];
         if(Boolean(styleName))
         {
            if(styleName is CSSStyleDeclaration)
            {
               classSelectors.push(CSSStyleDeclaration(styleName));
            }
            else
            {
               if(styleName is IFlexDisplayObject)
               {
                  StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                  return;
               }
               if(styleName is String)
               {
                  styleNames = styleName.split(/\s+/);
                  for(c = 0; c < styleNames.length; c++)
                  {
                     if(Boolean(styleNames[c].length))
                     {
                        classSelectors.push(styleManager.getMergedStyleDeclaration("." + styleNames[c]));
                     }
                  }
               }
            }
         }
         var nonInheritChain:Object = styleManager.stylesRoot;
         var p:IStyleClient = parent as IStyleClient;
         if(Boolean(p))
         {
            inheritChain = p.inheritingStyles;
            if(inheritChain == StyleProtoChain.STYLE_UNINITIALIZED)
            {
               inheritChain = nonInheritChain;
            }
         }
         else
         {
            inheritChain = styleManager.stylesRoot;
         }
         var typeSelectors:Array = this.getClassStyleDeclarations();
         var n:int = int(typeSelectors.length);
         for(var i:int = 0; i < n; i++)
         {
            typeSelector = typeSelectors[i];
            inheritChain = typeSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = typeSelector.addStyleToProtoChain(nonInheritChain,this);
         }
         for(i = 0; i < classSelectors.length; i++)
         {
            classSelector = classSelectors[i];
            if(Boolean(classSelector))
            {
               inheritChain = classSelector.addStyleToProtoChain(inheritChain,this);
               nonInheritChain = classSelector.addStyleToProtoChain(nonInheritChain,this);
            }
         }
         inheritingStyles = Boolean(this.styleDeclaration) ? this.styleDeclaration.addStyleToProtoChain(inheritChain,this) : inheritChain;
         nonInheritingStyles = Boolean(this.styleDeclaration) ? this.styleDeclaration.addStyleToProtoChain(nonInheritChain,this) : nonInheritChain;
      }
      
      public function clearStyle(styleProp:String) : void
      {
         this.setStyle(styleProp,undefined);
      }
      
      public function regenerateStyleCache(recursive:Boolean) : void
      {
         this.initProtoChain();
      }
      
      public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
      }
      
      public function registerEffects(effects:Array) : void
      {
      }
      
      public function get styleDeclaration() : CSSStyleDeclaration
      {
         return this._styleDeclaration;
      }
      
      public function set styleDeclaration(value:CSSStyleDeclaration) : void
      {
         this._styleDeclaration = value;
      }
   }
}


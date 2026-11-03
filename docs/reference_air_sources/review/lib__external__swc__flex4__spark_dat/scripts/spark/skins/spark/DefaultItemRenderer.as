package spark.skins.spark
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.controls.listClasses.*;
   import mx.core.IDataRenderer;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import spark.components.IItemRenderer;
   import spark.components.Label;
   import spark.components.supportClasses.InteractionState;
   import spark.components.supportClasses.InteractionStateDetector;
   import spark.components.supportClasses.TextBase;
   
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="downColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="spark, mobile")]
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
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class DefaultItemRenderer extends UIComponent implements IDataRenderer, IItemRenderer
   {
      
      private var interactionStateDetector:InteractionStateDetector;
      
      private var _data:Object;
      
      private var _itemIndex:int;
      
      private var _label:String = "";
      
      public var labelDisplay:TextBase;
      
      private var _showsCaret:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _dragging:Boolean = false;
      
      public function DefaultItemRenderer()
      {
         super();
         this.interactionStateDetector = new InteractionStateDetector(this);
         this.interactionStateDetector.addEventListener(Event.CHANGE,this.interactionStateDetector_changeHandler);
      }
      
      override public function get baselinePosition() : Number
      {
         if(!this.labelDisplay || !validateBaselinePosition())
         {
            return super.baselinePosition;
         }
         return this.labelDisplay.y + this.labelDisplay.baselinePosition;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         if(hasEventListener(FlexEvent.DATA_CHANGE))
         {
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         }
      }
      
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(value:int) : void
      {
         if(value == this._itemIndex)
         {
            return;
         }
         this._itemIndex = value;
         invalidateDisplayList();
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         if(value == this._label)
         {
            return;
         }
         this._label = value;
         if(Boolean(this.labelDisplay))
         {
            this.labelDisplay.text = this._label;
         }
      }
      
      public function get showsCaret() : Boolean
      {
         return this._showsCaret;
      }
      
      public function set showsCaret(value:Boolean) : void
      {
         if(value == this._showsCaret)
         {
            return;
         }
         this._showsCaret = value;
         invalidateDisplayList();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(value != this._selected)
         {
            this._selected = value;
            invalidateDisplayList();
         }
      }
      
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function set dragging(value:Boolean) : void
      {
         if(value == this._dragging)
         {
            return;
         }
         this._dragging = value;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.labelDisplay)
         {
            this.labelDisplay = new Label();
            addChild(DisplayObject(this.labelDisplay));
            if(this._label != "")
            {
               this.labelDisplay.text = this._label;
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = this.labelDisplay.getPreferredBoundsWidth() + 6;
         measuredHeight = this.labelDisplay.getPreferredBoundsHeight() + 10;
         measuredMinWidth = this.labelDisplay.getMinBoundsWidth() + 6;
         measuredMinHeight = this.labelDisplay.getMinBoundsHeight() + 10;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var backgroundColor:uint = 0;
         var alternatingColors:Array = null;
         var alternatingColorsStyle:Object = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         graphics.clear();
         var drawBackground:Boolean = true;
         var downColor:* = getStyle("downColor");
         if(this.interactionStateDetector.state == InteractionState.DOWN && downColor !== undefined)
         {
            backgroundColor = downColor;
         }
         else if(this.selected)
         {
            backgroundColor = uint(getStyle("selectionColor"));
         }
         else if(this.interactionStateDetector.state == InteractionState.OVER)
         {
            backgroundColor = uint(getStyle("rollOverColor"));
         }
         else
         {
            alternatingColorsStyle = getStyle("alternatingItemColors");
            if(Boolean(alternatingColorsStyle))
            {
               alternatingColors = alternatingColorsStyle is Array ? alternatingColorsStyle as Array : [alternatingColorsStyle];
            }
            if(Boolean(alternatingColors) && alternatingColors.length > 0)
            {
               styleManager.getColorNames(alternatingColors);
               backgroundColor = uint(alternatingColors[this.itemIndex % alternatingColors.length]);
            }
            else
            {
               drawBackground = false;
            }
         }
         graphics.beginFill(backgroundColor,drawBackground ? 1 : 0);
         if(this.showsCaret)
         {
            graphics.lineStyle(1,getStyle("selectionColor"));
            graphics.drawRect(0.5,0.5,unscaledWidth - 1,unscaledHeight - 1);
         }
         else
         {
            graphics.lineStyle();
            graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
         }
         graphics.endFill();
         var childWidth:Number = unscaledWidth - 6;
         childWidth = Math.max(this.labelDisplay.getMinBoundsWidth(),Math.min(this.labelDisplay.getMaxBoundsWidth(),childWidth));
         var childHeight:Number = unscaledHeight - 10;
         childHeight = Math.max(this.labelDisplay.getMinBoundsHeight(),Math.min(this.labelDisplay.getMaxBoundsHeight(),childHeight));
         this.labelDisplay.setLayoutBoundsSize(childWidth,childHeight);
         this.labelDisplay.setLayoutBoundsPosition(3,5);
      }
      
      private function interactionStateDetector_changeHandler(event:Event) : void
      {
         invalidateDisplayList();
      }
   }
}


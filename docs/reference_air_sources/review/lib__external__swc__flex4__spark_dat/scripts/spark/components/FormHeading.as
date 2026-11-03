package spark.components
{
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.core.IDisplayText;
   
   [IconFile("FormHeading.png")]
   [DiscouragedForProfile("mobileDevice")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",theme="spark")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",theme="spark")]
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
   public class FormHeading extends SkinnableComponent
   {
      
      private static var _skinParts:Object = {"labelDisplay":false};
      
      private var _1184053038labelDisplay:IDisplayText;
      
      private var _label:String = "";
      
      public function FormHeading()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="")]
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
         if(Boolean(this.labelDisplay))
         {
            this.labelDisplay.text = this.label;
         }
         dispatchEvent(new Event("labelChanged"));
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.labelDisplay)
         {
            this.labelDisplay.text = this.label;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         return enabled ? "normal" : "disabled";
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get labelDisplay() : IDisplayText
      {
         return this._1184053038labelDisplay;
      }
      
      public function set labelDisplay(param1:IDisplayText) : void
      {
         var _loc2_:Object = this._1184053038labelDisplay;
         if(_loc2_ !== param1)
         {
            this._1184053038labelDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelDisplay",_loc2_,param1));
            }
         }
      }
   }
}


package spark.components
{
   import mx.core.IVisualElement;
   import mx.core.UIComponentGlobals;
   import spark.components.supportClasses.DropDownListBase;
   import spark.components.supportClasses.TextBase;
   import spark.core.IDisplayText;
   import spark.utils.LabelUtil;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("DropDownList.png")]
   public class DropDownList extends DropDownListBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "dropIndicator":false,
         "scroller":false,
         "labelDisplay":false,
         "dataGroup":false,
         "openButton":true,
         "dropDown":false
      };
      
      [SkinPart(required="false")]
      public var labelDisplay:IDisplayText;
      
      private var labelChanged:Boolean = false;
      
      private var labelDisplayExplicitWidth:Number;
      
      private var labelDisplayExplicitHeight:Number;
      
      private var sizeSetByTypicalItem:Boolean;
      
      private var _prompt:String = "";
      
      public function DropDownList()
      {
         super();
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.labelDisplay as IVisualElement);
      }
      
      [Inspectable(category="General",defaultValue="")]
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(value:String) : void
      {
         if(this._prompt == value)
         {
            return;
         }
         this._prompt = value;
         this.labelChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      override public function set typicalItem(value:Object) : void
      {
         super.typicalItem = value;
         invalidateSize();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.labelChanged)
         {
            this.labelChanged = false;
            this.updateLabelDisplay();
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.labelDisplay)
         {
            this.labelChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function measure() : void
      {
         var labelComp:TextBase = this.labelDisplay as TextBase;
         if(Boolean(labelComp) && typicalItem != null)
         {
            if(!this.sizeSetByTypicalItem)
            {
               this.labelDisplayExplicitWidth = labelComp.explicitWidth;
               this.labelDisplayExplicitHeight = labelComp.explicitHeight;
               this.sizeSetByTypicalItem = true;
            }
            labelComp.explicitWidth = NaN;
            labelComp.explicitHeight = NaN;
            this.updateLabelDisplay(typicalItem);
            UIComponentGlobals.layoutManager.validateClient(skin,true);
            labelComp.width = labelComp.measuredWidth;
            labelComp.height = labelComp.measuredHeight;
            this.updateLabelDisplay();
         }
         else if(Boolean(labelComp) && Boolean(this.sizeSetByTypicalItem) && typicalItem == null)
         {
            labelComp.width = this.labelDisplayExplicitWidth;
            labelComp.height = this.labelDisplayExplicitHeight;
            this.sizeSetByTypicalItem = false;
         }
         super.measure();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function updateLabelDisplay(displayItem:* = undefined) : void
      {
         if(Boolean(this.labelDisplay))
         {
            if(displayItem == undefined)
            {
               displayItem = selectedItem;
            }
            if(displayItem != null && displayItem != undefined)
            {
               this.labelDisplay.text = LabelUtil.itemToLabel(displayItem,labelField,labelFunction);
            }
            else
            {
               this.labelDisplay.text = this.prompt;
            }
         }
      }
   }
}


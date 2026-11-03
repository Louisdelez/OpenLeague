package spark.components
{
   import flash.events.Event;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import spark.core.IDisplayText;
   
   [Style(name="errorIndicatorSource",type="Object",inherit="no")]
   [Style(name="requiredIndicatorSource",type="Object",inherit="no")]
   public class FormItem extends SkinnableContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "contentGroup":false,
         "labelDisplay":false,
         "sequenceLabelDisplay":false,
         "errorTextDisplay":false,
         "helpContentGroup":false
      };
      
      [SkinPart(required="false")]
      public var labelDisplay:IDisplayText;
      
      [SkinPart(required="false")]
      public var sequenceLabelDisplay:IDisplayText;
      
      [SkinPart(required="false")]
      public var helpContentGroup:Group;
      
      [SkinPart(required="false")]
      public var errorTextDisplay:IDisplayText;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _elementErrorStrings:Vector.<String> = new Vector.<String>();
      
      private var _helpContent:Array;
      
      private var helpContentChanged:Boolean = false;
      
      private var _label:String = "";
      
      private var _required:Boolean = false;
      
      private var _sequenceLabel:String = "";
      
      public function FormItem()
      {
         super();
         setStyle("showErrorSkin",false);
         setStyle("showErrorTip",false);
         showInAutomationHierarchy = false;
      }
      
      [Bindable(event="elementErrorStringsChanged")]
      public function get elementErrorStrings() : Vector.<String>
      {
         return this._elementErrorStrings;
      }
      
      [Inspectable(category="General",arrayType="mx.core.IVisualElement",defaultValue="")]
      [Bindable("helpContentChanged")]
      [ArrayElementType("mx.core.IVisualElement")]
      public function get helpContent() : Array
      {
         if(Boolean(this.helpContentGroup))
         {
            return this.helpContentGroup.getMXMLContent();
         }
         return this._helpContent;
      }
      
      public function set helpContent(value:Array) : void
      {
         this._helpContent = value;
         this.helpContentChanged = true;
         invalidateProperties();
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
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("requiredChanged")]
      public function get required() : Boolean
      {
         return this._required;
      }
      
      public function set required(value:Boolean) : void
      {
         if(value == this._required)
         {
            return;
         }
         this._required = value;
         invalidateSkinState();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("sequenceLabelChanged")]
      public function get sequenceLabel() : String
      {
         return this._sequenceLabel;
      }
      
      public function set sequenceLabel(value:String) : void
      {
         if(this._sequenceLabel == value)
         {
            return;
         }
         this._sequenceLabel = value;
         if(Boolean(this.sequenceLabelDisplay))
         {
            this.sequenceLabelDisplay.text = this.sequenceLabel;
         }
         dispatchEvent(new Event("sequenceLabelChanged"));
         invalidateProperties();
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.labelDisplay as IVisualElement);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.helpContentChanged)
         {
            this.createHelpContent();
            this.helpContentChanged = false;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         if(this.required)
         {
            if(!enabled)
            {
               return "requiredAndDisabled";
            }
            if(this.elementErrorStrings.length > 0)
            {
               return "requiredAndError";
            }
            return "required";
         }
         if(!enabled)
         {
            return "disabled";
         }
         if(this.elementErrorStrings.length > 0)
         {
            return "error";
         }
         return "normal";
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.labelDisplay)
         {
            this.labelDisplay.text = this.label;
         }
         else if(instance == this.sequenceLabelDisplay)
         {
            this.sequenceLabelDisplay.text = this.sequenceLabel;
         }
         else if(instance == this.errorTextDisplay)
         {
            this.updateErrorTextDisplay();
         }
         else if(instance == this.helpContentGroup)
         {
            this.helpContentChanged = true;
            this.createHelpContent();
         }
         else if(instance == contentGroup)
         {
            contentGroup.addEventListener("errorStringChanged",this.contentGroup_errorStringdHandler,true);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.helpContentGroup)
         {
            this.helpContentGroup.removeAllElements();
         }
         if(instance == contentGroup)
         {
            contentGroup.removeEventListener("errorStringChanged",this.contentGroup_errorStringdHandler,true);
         }
      }
      
      private function updateErrorString() : void
      {
         var uicElt:UIComponent = null;
         this._elementErrorStrings = new Vector.<String>();
         for(var i:int = 0; i < numElements; i++)
         {
            uicElt = getElementAt(i) as UIComponent;
            if(Boolean(uicElt))
            {
               if(uicElt.errorString != "")
               {
                  this._elementErrorStrings.push(uicElt.errorString);
               }
            }
         }
         invalidateSkinState();
         this.updateErrorTextDisplay();
         dispatchEvent(new Event("elementErrorStringsChanged"));
      }
      
      protected function updateErrorTextDisplay() : void
      {
         var msg:String = "";
         for(var i:int = 0; i < this.elementErrorStrings.length; i++)
         {
            if(msg != "")
            {
               msg += "\n";
            }
            msg += this.elementErrorStrings[i];
         }
         if(Boolean(this.errorTextDisplay))
         {
            this.errorTextDisplay.text = msg;
         }
         errorString = msg;
      }
      
      private function createHelpContent() : void
      {
         if(Boolean(this.helpContentGroup))
         {
            this.helpContentGroup.mxmlContent = this._helpContent;
         }
      }
      
      private function contentGroup_errorStringdHandler(event:Event) : void
      {
         this.updateErrorString();
      }
   }
}


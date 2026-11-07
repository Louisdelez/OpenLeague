package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.FlexGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.IMXMLObject;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   
   [Alternative(replacement="spark.components.RadioButtonGroup",since="4.0")]
   [IconFile("RadioButtonGroup.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selection",destination="selection")]
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class RadioButtonGroup extends EventDispatcher implements IMXMLObject
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var document:IFlexDisplayObject;
      
      private var radioButtons:Array = [];
      
      private var _labelPlacement:String = "right";
      
      private var _selectedValue:Object;
      
      private var _selection:RadioButton;
      
      public function RadioButtonGroup(document:IFlexDisplayObject = null)
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("enabledChanged")]
      public function get enabled() : Boolean
      {
         var s:Number = 0;
         var n:int = this.numRadioButtons;
         for(var i:int = 0; i < n; i++)
         {
            s += this.getRadioButtonAt(i).enabled;
         }
         if(s == 0)
         {
            return false;
         }
         if(s == n)
         {
            return true;
         }
         return false;
      }
      
      public function set enabled(value:Boolean) : void
      {
         var n:int = this.numRadioButtons;
         for(var i:int = 0; i < n; i++)
         {
            this.getRadioButtonAt(i).enabled = value;
         }
         dispatchEvent(new Event("enabledChanged"));
      }
      
      [Inspectable(category="General",enumeration="left,right,top,bottom",defaultValue="right")]
      [Bindable("labelPlacementChanged")]
      public function get labelPlacement() : String
      {
         return this._labelPlacement;
      }
      
      public function set labelPlacement(value:String) : void
      {
         this._labelPlacement = value;
         var n:int = this.numRadioButtons;
         for(var i:int = 0; i < n; i++)
         {
            this.getRadioButtonAt(i).labelPlacement = value;
         }
      }
      
      [Bindable("numRadioButtonsChanged")]
      public function get numRadioButtons() : int
      {
         return this.radioButtons.length;
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedValue() : Object
      {
         if(Boolean(this.selection))
         {
            return this.selection.value != null ? this.selection.value : this.selection.label;
         }
         return null;
      }
      
      public function set selectedValue(value:Object) : void
      {
         var radioButton:RadioButton = null;
         this._selectedValue = value;
         if(value == null)
         {
            this.setSelection(null,false);
            return;
         }
         var n:int = this.numRadioButtons;
         for(var i:int = 0; i < n; i++)
         {
            radioButton = this.getRadioButtonAt(i);
            if(radioButton.value == value || radioButton.label == value)
            {
               this.changeSelection(i,false);
               break;
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selection() : RadioButton
      {
         return this._selection;
      }
      
      public function set selection(value:RadioButton) : void
      {
         this.setSelection(value,false);
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this.document = Boolean(document) ? IFlexDisplayObject(document) : IFlexDisplayObject(FlexGlobals.topLevelApplication);
      }
      
      public function getRadioButtonAt(index:int) : RadioButton
      {
         return RadioButton(this.radioButtons[index]);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addInstance(instance:RadioButton) : void
      {
         instance.addEventListener(Event.REMOVED,this.radioButton_removedHandler);
         this.radioButtons.push(instance);
         this.radioButtons.sort(this.breadthOrderCompare);
         for(var i:int = 0; i < this.radioButtons.length; i++)
         {
            this.radioButtons[i].indexNumber = i;
         }
         if(this._selectedValue != null)
         {
            this.selectedValue = this._selectedValue;
         }
         dispatchEvent(new Event("numRadioButtonsChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeInstance(instance:RadioButton) : void
      {
         var foundInstance:Boolean = false;
         var i:int = 0;
         var rb:RadioButton = null;
         if(Boolean(instance))
         {
            foundInstance = false;
            for(i = 0; i < this.numRadioButtons; i++)
            {
               rb = this.getRadioButtonAt(i);
               if(foundInstance)
               {
                  --rb.indexNumber;
               }
               else if(rb == instance)
               {
                  rb.group = null;
                  if(instance == this._selection)
                  {
                     this._selection = null;
                  }
                  this.radioButtons.splice(i,1);
                  foundInstance = true;
                  i--;
               }
            }
            if(foundInstance)
            {
               dispatchEvent(new Event("numRadioButtonsChanged"));
            }
         }
      }
      
      private function getValue() : String
      {
         if(Boolean(this.selection))
         {
            return Boolean(this.selection.value) && Boolean(this.selection.value is String) && String(this.selection.value).length != 0 ? String(this.selection.value) : this.selection.label;
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelection(value:RadioButton, fireChange:Boolean = true) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(value == null)
         {
            if(this.selection != null)
            {
               this._selection.selected = false;
               this._selection = null;
               if(fireChange)
               {
                  dispatchEvent(new Event(Event.CHANGE));
               }
            }
         }
         else
         {
            n = this.numRadioButtons;
            for(i = 0; i < n; i++)
            {
               if(value == this.getRadioButtonAt(i))
               {
                  this.changeSelection(i,fireChange);
                  break;
               }
            }
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function changeSelection(index:int, fireChange:Boolean = true) : void
      {
         if(Boolean(this.getRadioButtonAt(index)))
         {
            if(Boolean(this.selection))
            {
               this.selection.selected = false;
            }
            this._selection = this.getRadioButtonAt(index);
            this._selection.selected = true;
            if(fireChange)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      private function breadthOrderCompare(a:DisplayObject, b:DisplayObject) : Number
      {
         var aParent:DisplayObject = a is UIComponent ? UIComponent(a).$parent : a.parent;
         var bParent:DisplayObject = b is UIComponent ? UIComponent(b).$parent : b.parent;
         if(!aParent || !bParent)
         {
            return 0;
         }
         var aNestLevel:int = a is UIComponent ? int(UIComponent(a).nestLevel) : -1;
         var bNestLevel:int = b is UIComponent ? int(UIComponent(b).nestLevel) : -1;
         var aIndex:int = DisplayObjectContainer(aParent).getChildIndex(a);
         var bIndex:int = DisplayObjectContainer(bParent).getChildIndex(b);
         if(aNestLevel > bNestLevel || a.parent == b.parent && aIndex > bIndex)
         {
            return 1;
         }
         if(aNestLevel < bNestLevel || a.parent == b.parent && bIndex > aIndex)
         {
            return -1;
         }
         if(a == b)
         {
            return 0;
         }
         return this.breadthOrderCompare(aParent,bParent);
      }
      
      private function radioButton_removedHandler(event:Event) : void
      {
         var rb:RadioButton = event.target as RadioButton;
         if(Boolean(rb))
         {
            rb.removeEventListener(Event.REMOVED,this.radioButton_removedHandler);
            this.removeInstance(RadioButton(event.target));
         }
      }
   }
}


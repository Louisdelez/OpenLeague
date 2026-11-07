package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.FlexGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.IMXMLObject;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.utils.NameUtil;
   
   [DefaultTriggerEvent("change")]
   [IconFile("RadioButtonGroup.png")]
   [Event(name="valueCommit",type="mx.events.FlexEvent")]
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class RadioButtonGroup extends EventDispatcher implements IMXMLObject
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _name:String;
      
      private var document:IFlexDisplayObject;
      
      private var radioButtons:Array = [];
      
      private var _enabled:Boolean = true;
      
      private var _selectedValue:Object;
      
      private var _selection:RadioButton;
      
      private var aSbRoot:DisplayObject;
      
      private var bSbRoot:DisplayObject;
      
      public function RadioButtonGroup(document:IFlexDisplayObject = null)
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            return;
         }
         this._enabled = value;
         for(var i:int = 0; i < this.numRadioButtons; i++)
         {
            this.getRadioButtonAt(i).invalidateSkinState();
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
               this._selectedValue = null;
               dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
               break;
            }
         }
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
         if(this._selection == value)
         {
            return;
         }
         this.setSelection(value,false);
      }
      
      public function initialized(document:Object, id:String) : void
      {
         this._name = id;
         this.document = Boolean(document) ? IFlexDisplayObject(document) : IFlexDisplayObject(FlexGlobals.topLevelApplication);
      }
      
      public function getRadioButtonAt(index:int) : RadioButton
      {
         if(index >= 0 && index < this.numRadioButtons)
         {
            return this.radioButtons[index];
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get name() : String
      {
         if(this._name == null)
         {
            this._name = NameUtil.createUniqueName(this);
         }
         return this._name;
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
         if(instance.selected == true)
         {
            this.selection = instance;
         }
         instance.radioButtonGroup = this;
         instance.invalidateSkinState();
         dispatchEvent(new Event("numRadioButtonsChanged"));
      }
      
      private function removeInstance(instance:RadioButton) : void
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
                  rb.indexNumber -= 1;
               }
               else if(rb == instance)
               {
                  instance.addEventListener(Event.ADDED,this.radioButton_addedHandler);
                  if(instance == this._selection)
                  {
                     this._selection = null;
                  }
                  instance.radioButtonGroup = null;
                  instance.invalidateSkinState();
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setSelection(value:RadioButton, fireChange:Boolean = true) : void
      {
         var n:int = 0;
         var i:int = 0;
         if(this._selection == value)
         {
            return;
         }
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
         var rb:RadioButton = this.getRadioButtonAt(index);
         if(Boolean(rb) && rb != this._selection)
         {
            if(Boolean(this._selection))
            {
               this._selection.selected = false;
            }
            this._selection = rb;
            this._selection.selected = true;
            if(fireChange)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      private function breadthOrderCompare(a:DisplayObject, b:DisplayObject) : Number
      {
         var aParent:DisplayObjectContainer = a.parent;
         var bParent:DisplayObjectContainer = b.parent;
         if(!aParent || !bParent)
         {
            return 0;
         }
         if(a is RadioButton)
         {
            this.aSbRoot = RadioButton(a).systemManager.getSandboxRoot();
         }
         if(b is RadioButton)
         {
            this.bSbRoot = RadioButton(b).systemManager.getSandboxRoot();
         }
         if(aParent == this.aSbRoot || bParent == this.bSbRoot)
         {
            return 0;
         }
         var aNestLevel:int = a is UIComponent ? int(UIComponent(a).nestLevel) : -1;
         var bNestLevel:int = b is UIComponent ? int(UIComponent(b).nestLevel) : -1;
         var aIndex:int = 0;
         var bIndex:int = 0;
         if(aParent == bParent)
         {
            if(aParent is IVisualElementContainer && a is IVisualElement)
            {
               aIndex = int(IVisualElementContainer(aParent).getElementIndex(IVisualElement(a)));
            }
            else
            {
               aIndex = DisplayObjectContainer(aParent).getChildIndex(a);
            }
            if(bParent is IVisualElementContainer && b is IVisualElement)
            {
               bIndex = int(IVisualElementContainer(bParent).getElementIndex(IVisualElement(b)));
            }
            else
            {
               bIndex = DisplayObjectContainer(bParent).getChildIndex(b);
            }
         }
         if(aNestLevel > bNestLevel || aIndex > bIndex)
         {
            return 1;
         }
         if(aNestLevel < bNestLevel || bIndex > aIndex)
         {
            return -1;
         }
         if(a == b)
         {
            return 0;
         }
         return this.breadthOrderCompare(aParent,bParent);
      }
      
      private function radioButton_addedHandler(event:Event) : void
      {
         var rb:RadioButton = event.target as RadioButton;
         if(Boolean(rb))
         {
            rb.removeEventListener(Event.ADDED,this.radioButton_addedHandler);
            this.addInstance(rb);
         }
      }
      
      private function radioButton_removedHandler(event:Event) : void
      {
         var rb:RadioButton = event.target as RadioButton;
         if(Boolean(rb))
         {
            rb.removeEventListener(Event.REMOVED,this.radioButton_removedHandler);
            this.removeInstance(rb);
         }
      }
   }
}


package spark.components
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.events.ItemClickEvent;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerGroup;
   import spark.components.supportClasses.ToggleButtonBase;
   
   [IconFile("RadioButton.png")]
   [AccessibilityClass(implementation="spark.accessibility.RadioButtonAccImpl")]
   [Exclude(name="textAlign",kind="style")]
   [Exclude(name="icon",kind="style")]
   [Exclude(name="cornerRadius",kind="style")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="iconPlacement",type="String",enumeration="top,bottom,right,left",inherit="no",theme="mobile")]
   public class RadioButton extends ToggleButtonBase implements IFocusManagerGroup
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const focusExclusions:Array = ["labelDisplay"];
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var indexNumber:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var radioButtonGroup:RadioButtonGroup = null;
      
      private var _group:RadioButtonGroup;
      
      private var _groupName:String;
      
      private var groupChanged:Boolean = false;
      
      private var _value:Object;
      
      public function RadioButton()
      {
         super();
         this.groupName = "radioGroup";
      }
      
      override public function get enabled() : Boolean
      {
         if(!super.enabled)
         {
            return false;
         }
         return !this.radioButtonGroup || this.radioButtonGroup.enabled;
      }
      
      override public function get suggestedFocusSkinExclusions() : Array
      {
         return focusExclusions;
      }
      
      private function get autoGroupIndex() : String
      {
         return "_spark_" + this.groupName;
      }
      
      public function get group() : RadioButtonGroup
      {
         var g:RadioButtonGroup = null;
         if(!document)
         {
            return this._group;
         }
         if(!this._group)
         {
            if(Boolean(this.groupName) && this.groupName != "")
            {
               try
               {
                  g = RadioButtonGroup(document[this.groupName]);
               }
               catch(e:Error)
               {
                  if(Boolean(document.automaticRadioButtonGroups) && Boolean(document.automaticRadioButtonGroups[autoGroupIndex]))
                  {
                     g = RadioButtonGroup(document.automaticRadioButtonGroups[autoGroupIndex]);
                  }
               }
               if(!g)
               {
                  g = new RadioButtonGroup(IFlexDisplayObject(document));
                  if(!document.automaticRadioButtonGroups)
                  {
                     document.automaticRadioButtonGroups = [];
                  }
                  document.automaticRadioButtonGroups[this.autoGroupIndex] = g;
               }
               else if(!(g is RadioButtonGroup))
               {
                  return null;
               }
               this._group = g;
            }
         }
         return this._group;
      }
      
      public function set group(value:RadioButtonGroup) : void
      {
         if(this._group == value)
         {
            return;
         }
         this.removeFromGroup();
         this._group = value;
         this._groupName = Boolean(value) ? this.group.name : "radioGroup";
         this.groupChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="radioGroup")]
      public function get groupName() : String
      {
         return this._groupName;
      }
      
      public function set groupName(value:String) : void
      {
         if(!value || value == "")
         {
            return;
         }
         this.removeFromGroup();
         this._groupName = value;
         this._group = null;
         this.groupChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function set selected(value:Boolean) : void
      {
         super.selected = value;
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("valueChanged")]
      [Bindable("change")]
      public function get value() : Object
      {
         return this._value;
      }
      
      public function set value(value:Object) : void
      {
         if(this._value == value)
         {
            return;
         }
         this._value = value;
         if(selected && Boolean(this.group))
         {
            this.group.dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(RadioButton.createAccessibilityImplementation != null)
         {
            RadioButton.createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         if(this.groupChanged)
         {
            this.addToGroup();
            this.groupChanged = false;
         }
         super.commitProperties();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.group))
         {
            if(selected)
            {
               this._group.selection = this;
            }
            else if(this.group.selection == this)
            {
               this._group.selection = null;
            }
         }
      }
      
      override protected function buttonReleased() : void
      {
         if(!this.enabled || selected)
         {
            return;
         }
         if(!this.radioButtonGroup)
         {
            this.addToGroup();
         }
         super.buttonReleased();
         this.group.setSelection(this);
         var itemClickEvent:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         itemClickEvent.label = label;
         itemClickEvent.index = this.indexNumber;
         itemClickEvent.relatedObject = this;
         itemClickEvent.item = this.value;
         this.group.dispatchEvent(itemClickEvent);
      }
      
      private function addToGroup() : RadioButtonGroup
      {
         var g:RadioButtonGroup = this.group;
         if(Boolean(g))
         {
            g.addInstance(this);
         }
         return g;
      }
      
      private function removeFromGroup() : void
      {
         this.dispatchEvent(new Event(Event.REMOVED));
         try
         {
            if(document.automaticRadioButtonGroups[this.autoGroupIndex].numRadioButtons == 0)
            {
               delete document.automaticRadioButtonGroups[this.autoGroupIndex];
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function setPrev(moveSelection:Boolean = true) : void
      {
         var radioButton:RadioButton = null;
         var g:RadioButtonGroup = this.group;
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         for(var i:int = 1; i <= this.indexNumber; i++)
         {
            radioButton = g.getRadioButtonAt(this.indexNumber - i);
            if(Boolean(radioButton) && this.isRadioButtonEnabled(radioButton))
            {
               if(moveSelection)
               {
                  g.setSelection(radioButton);
               }
               radioButton.setFocus();
               return;
            }
         }
         if(moveSelection && g.getRadioButtonAt(this.indexNumber) != g.selection)
         {
            g.setSelection(this);
         }
         this.drawFocus(true);
      }
      
      private function setNext(moveSelection:Boolean = true) : void
      {
         var radioButton:RadioButton = null;
         var g:RadioButtonGroup = this.group;
         var fm:IFocusManager = focusManager;
         if(Boolean(fm))
         {
            fm.showFocusIndicator = true;
         }
         for(var i:int = this.indexNumber + 1; i < g.numRadioButtons; i++)
         {
            radioButton = g.getRadioButtonAt(i);
            if(Boolean(radioButton) && this.isRadioButtonEnabled(radioButton))
            {
               if(moveSelection)
               {
                  g.setSelection(radioButton);
               }
               radioButton.setFocus();
               return;
            }
         }
         if(moveSelection && g.getRadioButtonAt(this.indexNumber) != g.selection)
         {
            g.setSelection(this);
         }
         this.drawFocus(true);
      }
      
      private function isRadioButtonEnabled(rb:RadioButton) : Boolean
      {
         if(!rb.enabled)
         {
            return false;
         }
         var sbRoot:DisplayObject = rb.systemManager.getSandboxRoot();
         var p:DisplayObject = rb.parent;
         while(Boolean(p) && p != sbRoot)
         {
            if(p is UIComponent && !UIComponent(p).enabled)
            {
               return false;
            }
            p = p.parent;
         }
         return true;
      }
      
      private function setThis() : void
      {
         if(!this.radioButtonGroup)
         {
            this.addToGroup();
         }
         var g:RadioButtonGroup = this.group;
         if(g.selection != this)
         {
            g.setSelection(this);
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         switch(keyCode)
         {
            case Keyboard.DOWN:
               this.setNext(!event.ctrlKey);
               event.preventDefault();
               break;
            case Keyboard.UP:
               this.setPrev(!event.ctrlKey);
               event.preventDefault();
               break;
            case Keyboard.LEFT:
               this.setPrev(!event.ctrlKey);
               event.preventDefault();
               break;
            case Keyboard.RIGHT:
               this.setNext(!event.ctrlKey);
               event.preventDefault();
               break;
            case Keyboard.SPACE:
               this.setThis();
            default:
               super.keyDownHandler(event);
         }
      }
   }
}


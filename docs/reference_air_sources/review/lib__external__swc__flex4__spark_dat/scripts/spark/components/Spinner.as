package spark.components
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import mx.events.FlexEvent;
   import mx.managers.IFocusManagerComponent;
   import spark.components.supportClasses.Range;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("Spinner.png")]
   [AccessibilityClass(implementation="spark.accessibility.SpinnerAccImpl")]
   [SkinState("disabled")]
   [SkinState("normal")]
   [Event(name="change",type="flash.events.Event")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="focusColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="focusAlpha",type="Number",inherit="no",theme="spark",minValue="0.0",maxValue="1.0")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="spark",minValue="0.0")]
   public class Spinner extends Range implements IFocusManagerComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "incrementButton":false,
         "decrementButton":false
      };
      
      [SkinPart(required="false")]
      public var decrementButton:Button;
      
      [SkinPart(required="false")]
      public var incrementButton:Button;
      
      private var _allowValueWrap:Boolean = false;
      
      public function Spinner()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get allowValueWrap() : Boolean
      {
         return this._allowValueWrap;
      }
      
      public function set allowValueWrap(value:Boolean) : void
      {
         this._allowValueWrap = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(Spinner.createAccessibilityImplementation != null)
         {
            Spinner.createAccessibilityImplementation(this);
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.incrementButton)
         {
            this.incrementButton.focusEnabled = false;
            this.incrementButton.addEventListener(FlexEvent.BUTTON_DOWN,this.incrementButton_buttonDownHandler);
            this.incrementButton.autoRepeat = true;
         }
         else if(instance == this.decrementButton)
         {
            this.decrementButton.focusEnabled = false;
            this.decrementButton.addEventListener(FlexEvent.BUTTON_DOWN,this.decrementButton_buttonDownHandler);
            this.decrementButton.autoRepeat = true;
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.incrementButton)
         {
            this.incrementButton.removeEventListener(FlexEvent.BUTTON_DOWN,this.incrementButton_buttonDownHandler);
         }
         else if(instance == this.decrementButton)
         {
            this.decrementButton.removeEventListener(FlexEvent.BUTTON_DOWN,this.decrementButton_buttonDownHandler);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         return enabled ? "normal" : "disabled";
      }
      
      override public function changeValueByStep(increase:Boolean = true) : void
      {
         if(this.allowValueWrap)
         {
            if(increase && value == maximum)
            {
               value = minimum;
            }
            else if(!increase && value == minimum)
            {
               value = maximum;
            }
            else
            {
               super.changeValueByStep(increase);
            }
         }
         else
         {
            super.changeValueByStep(increase);
         }
      }
      
      protected function incrementButton_buttonDownHandler(event:Event) : void
      {
         var prevValue:Number = this.value;
         this.changeValueByStep(true);
         if(value != prevValue)
         {
            dispatchEvent(new Event("change"));
         }
      }
      
      protected function decrementButton_buttonDownHandler(event:Event) : void
      {
         var prevValue:Number = this.value;
         this.changeValueByStep(false);
         if(value != prevValue)
         {
            dispatchEvent(new Event("change"));
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         var prevValue:Number = this.value;
         switch(event.keyCode)
         {
            case Keyboard.DOWN:
               this.changeValueByStep(false);
               event.preventDefault();
               break;
            case Keyboard.UP:
               this.changeValueByStep(true);
               event.preventDefault();
               break;
            case Keyboard.HOME:
               value = minimum;
               event.preventDefault();
               break;
            case Keyboard.END:
               value = maximum;
               event.preventDefault();
               break;
            default:
               super.keyDownHandler(event);
         }
         if(value != prevValue)
         {
            dispatchEvent(new Event("change"));
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_WHEEL,this.system_mouseWheelHandler,true);
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_WHEEL,this.system_mouseWheelHandler,true);
      }
      
      protected function system_mouseWheelHandler(event:MouseEvent) : void
      {
         var newValue:Number = NaN;
         if(!event.isDefaultPrevented())
         {
            newValue = nearestValidValue(value + event.delta * stepSize,stepSize);
            setValue(newValue);
            dispatchEvent(new Event(Event.CHANGE));
            event.preventDefault();
         }
      }
   }
}


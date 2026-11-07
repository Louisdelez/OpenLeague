package spark.components.supportClasses
{
   import flash.events.Event;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   
   [AccessibilityClass(implementation="spark.accessibility.ToggleButtonAccImpl")]
   [SkinState("disabledAndSelected")]
   [SkinState("downAndSelected")]
   [SkinState("overAndSelected")]
   [SkinState("upAndSelected")]
   [Event(name="change",type="flash.events.Event")]
   public class ToggleButtonBase extends ButtonBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      private var _selected:Boolean;
      
      public function ToggleButtonBase()
      {
         super();
         disableMinimumDownStateTime = true;
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable(event="propertyChange")]
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function set _1191572123selected(value:Boolean) : void
      {
         if(value == this._selected)
         {
            return;
         }
         this._selected = value;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         invalidateSkinState();
      }
      
      override protected function getCurrentSkinState() : String
      {
         if(!this.selected)
         {
            return super.getCurrentSkinState();
         }
         return super.getCurrentSkinState() + "AndSelected";
      }
      
      override protected function buttonReleased() : void
      {
         super.buttonReleased();
         this.selected = !this.selected;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ToggleButtonBase.createAccessibilityImplementation != null)
         {
            ToggleButtonBase.createAccessibilityImplementation(this);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:Object = this.selected;
         if(_loc2_ !== param1)
         {
            this._1191572123selected = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selected",_loc2_,param1));
            }
         }
      }
   }
}


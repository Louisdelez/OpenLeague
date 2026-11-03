package spark.components
{
   import flash.events.Event;
   
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   public class ButtonBarButton extends ToggleButton implements IItemRenderer
   {
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      private var _allowDeselection:Boolean = true;
      
      private var _showsCaret:Boolean = false;
      
      private var _itemIndex:int;
      
      private var _label:String = "";
      
      public function ButtonBarButton()
      {
         super();
      }
      
      public function get allowDeselection() : Boolean
      {
         return this._allowDeselection;
      }
      
      public function set allowDeselection(value:Boolean) : void
      {
         this._allowDeselection = value;
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
         drawFocusAnyway = true;
         drawFocus(value);
      }
      
      public function get dragging() : Boolean
      {
         return false;
      }
      
      public function set dragging(value:Boolean) : void
      {
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return content;
      }
      
      public function set data(value:Object) : void
      {
         content = value;
         dispatchEvent(new Event("dataChange"));
      }
      
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(value:int) : void
      {
         this._itemIndex = value;
      }
      
      override public function get label() : String
      {
         return this._label;
      }
      
      override public function set label(value:String) : void
      {
         if(value != this._label)
         {
            this._label = value;
            if(Boolean(labelDisplay))
            {
               labelDisplay.text = this._label;
            }
         }
      }
      
      override protected function buttonReleased() : void
      {
         if(selected && !this.allowDeselection)
         {
            return;
         }
         super.buttonReleased();
      }
   }
}


package mx.controls
{
   import flash.ui.Keyboard;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.controls.scrollClasses.ScrollBarDirection;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("VScrollBar.png")]
   [DefaultTriggerEvent("scroll")]
   [DefaultBindingProperty(source="scrollPosition",destination="scrollPosition")]
   [Exclude(name="direction",kind="property")]
   [Style(name="repeatInterval",type="Number",format="Time",inherit="no")]
   [Style(name="repeatDelay",type="Number",format="Time",inherit="no")]
   [Event(name="scroll",type="mx.events.ScrollEvent")]
   public class VScrollBar extends ScrollBar
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function VScrollBar()
      {
         super();
         super.direction = ScrollBarDirection.VERTICAL;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = _minWidth;
         measuredHeight = _minHeight;
      }
      
      override public function get minHeight() : Number
      {
         return _minHeight;
      }
      
      override mx_internal function isScrollBarKey(key:uint) : Boolean
      {
         if(key == Keyboard.UP)
         {
            lineScroll(-1);
            return true;
         }
         if(key == Keyboard.DOWN)
         {
            lineScroll(1);
            return true;
         }
         if(key == Keyboard.PAGE_UP)
         {
            pageScroll(-1);
            return true;
         }
         if(key == Keyboard.PAGE_DOWN)
         {
            pageScroll(1);
            return true;
         }
         return super.mx_internal::isScrollBarKey(key);
      }
      
      override public function get minWidth() : Number
      {
         return _minWidth;
      }
      
      [Inspectable(environment="none")]
      override public function set direction(value:String) : void
      {
      }
   }
}


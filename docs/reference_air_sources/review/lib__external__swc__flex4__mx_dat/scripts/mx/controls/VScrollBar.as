package mx.controls
{
   import flash.ui.Keyboard;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.controls.scrollClasses.ScrollBarDirection;
   
   [Alternative(replacement="spark.components.VScrollBar",since="4.0")]
   [IconFile("VScrollBar.png")]
   [DefaultTriggerEvent("scroll")]
   [DefaultBindingProperty(source="scrollPosition",destination="scrollPosition")]
   [Exclude(name="direction",kind="property")]
   [Style(name="repeatInterval",type="Number",format="Time",inherit="no")]
   [Style(name="repeatDelay",type="Number",format="Time",inherit="no")]
   [Event(name="scroll",type="mx.events.ScrollEvent")]
   public class VScrollBar extends ScrollBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function VScrollBar()
      {
         super();
         super.direction = ScrollBarDirection.VERTICAL;
      }
      
      [Inspectable(environment="none")]
      override public function set direction(value:String) : void
      {
      }
      
      override public function get minWidth() : Number
      {
         return _minWidth;
      }
      
      override public function get minHeight() : Number
      {
         return _minHeight;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = _minWidth;
         measuredHeight = _minHeight;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isScrollBarKey(key:uint) : Boolean
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
         return super.isScrollBarKey(key);
      }
   }
}


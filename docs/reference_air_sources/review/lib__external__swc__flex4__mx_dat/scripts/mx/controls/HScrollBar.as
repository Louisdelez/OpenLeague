package mx.controls
{
   import flash.geom.Matrix;
   import flash.ui.Keyboard;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.controls.scrollClasses.ScrollBarDirection;
   import mx.core.LayoutDirection;
   
   [Alternative(replacement="spark.components.HScrollBar",since="4.0")]
   [IconFile("HScrollBar.png")]
   [DefaultTriggerEvent("scroll")]
   [DefaultBindingProperty(source="scrollPosition",destination="scrollPosition")]
   [Exclude(name="direction",kind="property")]
   [Style(name="repeatInterval",type="Number",format="Time",inherit="no")]
   [Style(name="repeatDelay",type="Number",format="Time",inherit="no")]
   [Event(name="scroll",type="mx.events.ScrollEvent")]
   public class HScrollBar extends ScrollBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function HScrollBar()
      {
         super();
         super.direction = ScrollBarDirection.HORIZONTAL;
         scaleX = -1;
         rotation = -90;
      }
      
      [Inspectable(environment="none")]
      override public function set direction(value:String) : void
      {
      }
      
      override public function get minWidth() : Number
      {
         return _minHeight;
      }
      
      override public function get minHeight() : Number
      {
         return _minWidth;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualHeight() : Number
      {
         return unscaledWidth;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualWidth() : Number
      {
         return unscaledHeight;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = _minHeight;
         measuredHeight = _minWidth;
      }
      
      override protected function nonDeltaLayoutMatrix() : Matrix
      {
         var m:Matrix = new Matrix(0,1,1,0);
         var m1:Matrix = super.nonDeltaLayoutMatrix();
         if(Boolean(m1))
         {
            m.concat(m1);
         }
         return m;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isScrollBarKey(key:uint) : Boolean
      {
         var direction:int = 0;
         if(key == Keyboard.LEFT)
         {
            direction = Boolean(LayoutDirection.LTR) ? -1 : 1;
            lineScroll(direction);
            return true;
         }
         if(key == Keyboard.RIGHT)
         {
            direction = Boolean(LayoutDirection.LTR) ? 1 : -1;
            lineScroll(direction);
            return true;
         }
         return super.isScrollBarKey(key);
      }
   }
}


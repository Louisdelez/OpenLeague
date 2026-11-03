package flexlib.mdi.effects.effectClasses
{
   import flash.geom.Point;
   import flexlib.mdi.containers.MDIWindow;
   
   public class MDIGroupEffectItem
   {
      
      public var widthTo:Number = 0;
      
      public var moveTo:Point = new Point();
      
      public var window:MDIWindow;
      
      public var heightFrom:Number = 0;
      
      public var widthFrom:Number = 0;
      
      public var heightTo:Number = 0;
      
      public function MDIGroupEffectItem(window:MDIWindow)
      {
         super();
         this.window = window;
      }
      
      public function setWindowSize() : void
      {
         this.window.width = this.widthTo;
         this.window.height = this.heightTo;
      }
      
      public function get isCorrectPosition() : Boolean
      {
         return window.x == moveTo.x && window.y == moveTo.y;
      }
      
      public function get isCorrectSize() : Boolean
      {
         return window.height == heightTo && window.width == widthTo;
      }
      
      public function get isInPlace() : Boolean
      {
         return isCorrectSize && isCorrectPosition;
      }
   }
}


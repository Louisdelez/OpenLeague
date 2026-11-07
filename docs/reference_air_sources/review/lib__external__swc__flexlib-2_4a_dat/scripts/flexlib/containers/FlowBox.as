package flexlib.containers
{
   import flexlib.containers.utilityClasses.FlowLayout;
   import mx.containers.Box;
   import mx.containers.BoxDirection;
   
   public class FlowBox extends Box
   {
      
      public function FlowBox()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
         layoutObject = new FlowLayout();
         layoutObject.target = this;
      }
      
      override public function set direction(value:String) : void
      {
         super.direction = BoxDirection.HORIZONTAL;
      }
   }
}


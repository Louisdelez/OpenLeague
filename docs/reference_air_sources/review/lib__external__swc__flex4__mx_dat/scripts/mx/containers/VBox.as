package mx.containers
{
   [Alternative(replacement="spark.components.BorderContainer",since="4.0")]
   [Alternative(replacement="spark.components.VGroup",since="4.0")]
   [IconFile("VBox.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="direction",kind="property")]
   public class VBox extends Box
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function VBox()
      {
         super();
         layoutObject.direction = BoxDirection.VERTICAL;
      }
      
      [Inspectable(environment="none")]
      override public function set direction(value:String) : void
      {
      }
   }
}


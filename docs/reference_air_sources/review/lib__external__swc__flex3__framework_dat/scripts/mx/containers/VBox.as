package mx.containers
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
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
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function VBox()
      {
         super();
         mx_internal::layoutObject.direction = BoxDirection.VERTICAL;
      }
      
      [Inspectable(environment="none")]
      override public function set direction(value:String) : void
      {
      }
   }
}


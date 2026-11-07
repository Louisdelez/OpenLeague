package mx.skins.halo
{
   import mx.core.EdgeMetrics;
   import mx.core.mx_internal;
   import mx.skins.Border;
   
   use namespace mx_internal;
   
   public class LinkButtonSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function LinkButtonSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var cornerRadius:Number = getStyle("cornerRadius");
         var rollOverColor:uint = getStyle("rollOverColor");
         var selectionColor:uint = getStyle("selectionColor");
         graphics.clear();
         switch(name)
         {
            case "upSkin":
               drawRoundRect(0,0,w,h,cornerRadius,0,0);
               break;
            case "overSkin":
               drawRoundRect(0,0,w,h,cornerRadius,rollOverColor,1);
               break;
            case "downSkin":
               drawRoundRect(0,0,w,h,cornerRadius,selectionColor,1);
               break;
            case "disabledSkin":
               drawRoundRect(0,0,w,h,cornerRadius,0,0);
         }
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
   }
}


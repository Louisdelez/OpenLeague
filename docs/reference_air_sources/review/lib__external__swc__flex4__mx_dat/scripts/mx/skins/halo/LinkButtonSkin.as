package mx.skins.halo
{
   import mx.core.EdgeMetrics;
   import mx.skins.Border;
   
   public class LinkButtonSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function LinkButtonSkin()
      {
         super();
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return EdgeMetrics.EMPTY;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var rollOverColor:uint = uint(getStyle("rollOverColor"));
         var selectionColor:uint = uint(getStyle("selectionColor"));
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
   }
}


package mx.skins.halo
{
   import mx.skins.ProgrammaticSkin;
   
   public class StatusBarBackgroundSkin extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public function StatusBarBackgroundSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         graphics.clear();
         drawRoundRect(0,0,unscaledWidth,unscaledHeight,null,getStyle("statusBarBackgroundColor"),1);
         graphics.moveTo(0,0);
         graphics.lineStyle(1,0,0.35);
         graphics.lineTo(unscaledWidth,0);
      }
   }
}


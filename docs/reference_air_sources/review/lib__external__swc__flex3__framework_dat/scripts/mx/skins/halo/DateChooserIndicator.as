package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   
   use namespace mx_internal;
   
   public class DateChooserIndicator extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var indicatorColor:String = "rollOverColor";
      
      public function DateChooserIndicator()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.lineStyle(0,getStyle("themeColor"),0);
         g.beginFill(getStyle(indicatorColor));
         g.drawRect(1,0,w - 2,h);
         g.endFill();
      }
   }
}


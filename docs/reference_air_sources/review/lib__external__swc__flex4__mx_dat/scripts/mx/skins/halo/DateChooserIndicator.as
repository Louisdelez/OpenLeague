package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class DateChooserIndicator extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var indicatorColor:String = "rollOverColor";
      
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
         g.beginFill(getStyle(this.indicatorColor));
         g.drawRect(1,0,w - 2,h);
         g.endFill();
      }
   }
}


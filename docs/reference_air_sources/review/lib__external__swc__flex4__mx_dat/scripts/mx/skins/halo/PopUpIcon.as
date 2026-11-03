package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class PopUpIcon extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var arrowColor:uint = 1118481;
      
      public function PopUpIcon()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 6;
      }
      
      override public function get measuredHeight() : Number
      {
         return 4;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.beginFill(this.arrowColor);
         g.moveTo(w / 2,height);
         g.lineTo(0,0);
         g.lineTo(w,0);
         g.lineTo(w / 2,h);
         g.endFill();
      }
   }
}


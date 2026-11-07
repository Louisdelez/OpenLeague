package
{
   import com.utils.Lib;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import mx.flash.ContainerMovieClip;
   import mx.flash.FlexContentHolder;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol146")]
   public class MyContainer extends ContainerMovieClip
   {
      
      public var bg_mc:MovieClip;
      
      public var overlay_mc:MovieClip;
      
      public var compHolder:FlexContentHolder;
      
      public function MyContainer()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.overlay_mc.buttonMode = false;
         this.overlay_mc.mouseEnabled = false;
         this.addListeners();
      }
      
      public function addListeners() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onClick);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function onClick(evt:MouseEvent) : void
      {
         Lib.output("onClick!!!");
         this.overlay_mc.gotoAndStop(1);
      }
      
      private function onOver(evt:MouseEvent) : void
      {
         Lib.output("onOver!!!");
         this.overlay_mc.gotoAndStop(2);
      }
      
      private function onOut(evt:MouseEvent) : void
      {
         this.overlay_mc.gotoAndStop(3);
      }
   }
}


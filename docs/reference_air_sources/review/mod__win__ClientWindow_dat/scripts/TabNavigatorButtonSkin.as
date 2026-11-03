package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol25")]
   public dynamic class TabNavigatorButtonSkin extends UIMovieClip
   {
      
      public function TabNavigatorButtonSkin()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         this.stop();
      }
   }
}


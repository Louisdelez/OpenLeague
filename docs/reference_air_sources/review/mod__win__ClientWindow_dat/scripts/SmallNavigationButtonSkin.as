package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol308")]
   public dynamic class SmallNavigationButtonSkin extends UIMovieClip
   {
      
      public function SmallNavigationButtonSkin()
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


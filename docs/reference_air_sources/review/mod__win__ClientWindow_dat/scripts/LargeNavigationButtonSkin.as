package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol46")]
   public dynamic class LargeNavigationButtonSkin extends UIMovieClip
   {
      
      public function LargeNavigationButtonSkin()
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


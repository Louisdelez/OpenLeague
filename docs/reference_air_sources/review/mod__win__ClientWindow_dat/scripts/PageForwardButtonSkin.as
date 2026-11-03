package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol327")]
   public dynamic class PageForwardButtonSkin extends UIMovieClip
   {
      
      public function PageForwardButtonSkin()
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


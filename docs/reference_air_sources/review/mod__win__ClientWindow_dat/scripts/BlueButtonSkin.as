package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol33")]
   public dynamic class BlueButtonSkin extends UIMovieClip
   {
      
      public function BlueButtonSkin()
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


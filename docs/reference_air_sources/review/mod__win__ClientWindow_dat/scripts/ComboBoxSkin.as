package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol13")]
   public dynamic class ComboBoxSkin extends UIMovieClip
   {
      
      public function ComboBoxSkin()
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


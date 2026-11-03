package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol433")]
   public dynamic class SummonerButtonSkin extends UIMovieClip
   {
      
      public function SummonerButtonSkin()
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


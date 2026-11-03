package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol10")]
   public dynamic class cs_tradeMenuMessage extends UIMovieClip
   {
      
      public function cs_tradeMenuMessage()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}


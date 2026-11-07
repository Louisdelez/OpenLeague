package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol35")]
   public dynamic class cs_timerRight extends UIMovieClip
   {
      
      public var timerTxtMc:timer_timerTxtMc;
      
      public function cs_timerRight()
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


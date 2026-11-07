package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol40")]
   public dynamic class cs_timerLeft extends UIMovieClip
   {
      
      public var timerTxtMc:timer_timerTxtMc;
      
      public function cs_timerLeft()
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


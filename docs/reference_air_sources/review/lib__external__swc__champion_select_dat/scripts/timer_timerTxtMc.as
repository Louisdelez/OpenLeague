package
{
   import flash.text.TextField;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol28")]
   public dynamic class timer_timerTxtMc extends UIMovieClip
   {
      
      public var timerTxt:TextField;
      
      public function timer_timerTxtMc()
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


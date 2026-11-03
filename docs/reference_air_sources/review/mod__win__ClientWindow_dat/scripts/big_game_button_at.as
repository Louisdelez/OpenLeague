package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol428")]
   public dynamic class big_game_button_at extends UIMovieClip
   {
      
      public var button_text_mc:MovieClip;
      
      public function big_game_button_at()
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


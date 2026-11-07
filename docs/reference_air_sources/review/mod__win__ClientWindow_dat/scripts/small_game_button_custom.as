package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol418")]
   public dynamic class small_game_button_custom extends UIMovieClip
   {
      
      public var button_text_mc:MovieClip;
      
      public function small_game_button_custom()
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


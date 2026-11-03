package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol228")]
   public dynamic class big_game_button_normal extends UIMovieClip
   {
      
      public var button_text_mc:MovieClip;
      
      public function big_game_button_normal()
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


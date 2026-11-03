package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol379")]
   public dynamic class big_game_button_ranked extends UIMovieClip
   {
      
      public var rankedAnim:MovieClip;
      
      public var button_text_mc:MovieClip;
      
      public function big_game_button_ranked()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         this.rankedAnim.gotoAndPlay(2);
      }
   }
}


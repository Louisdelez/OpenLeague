package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol360")]
   public dynamic class smallGameButton_tutorialBattleTraining extends UIMovieClip
   {
      
      public var button_text_mc:MovieClip;
      
      public function smallGameButton_tutorialBattleTraining()
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


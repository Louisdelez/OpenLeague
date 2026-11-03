package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol80")]
   public dynamic class cs_mainMenu extends UIMovieClip
   {
      
      public var mainMenu_nameText2:MovieClip;
      
      public var mainMenu_nameText1:MovieClip;
      
      public function cs_mainMenu()
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


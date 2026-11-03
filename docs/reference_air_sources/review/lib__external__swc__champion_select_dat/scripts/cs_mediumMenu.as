package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public dynamic class cs_mediumMenu extends UIMovieClip
   {
      
      public var smallMenu_nameText:MovieClip;
      
      public function cs_mediumMenu()
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


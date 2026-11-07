package
{
   import flash.display.MovieClip;
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol49")]
   public dynamic class cs_smallMenu extends UIMovieClip
   {
      
      public var smallMenu_nameText:MovieClip;
      
      public function cs_smallMenu()
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


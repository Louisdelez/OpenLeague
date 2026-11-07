package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol449")]
   public dynamic class pg_tooltip_normal extends UIMovieClip
   {
      
      public function pg_tooltip_normal()
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


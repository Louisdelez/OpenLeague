package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol413")]
   public dynamic class pg_tooltip_at extends UIMovieClip
   {
      
      public function pg_tooltip_at()
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


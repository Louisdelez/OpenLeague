package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol175")]
   public dynamic class scrollbar_track_v extends UIMovieClip
   {
      
      public function scrollbar_track_v()
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


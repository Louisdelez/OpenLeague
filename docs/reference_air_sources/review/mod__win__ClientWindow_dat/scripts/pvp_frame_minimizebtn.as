package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol342")]
   public dynamic class pvp_frame_minimizebtn extends UIMovieClip
   {
      
      public function pvp_frame_minimizebtn()
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


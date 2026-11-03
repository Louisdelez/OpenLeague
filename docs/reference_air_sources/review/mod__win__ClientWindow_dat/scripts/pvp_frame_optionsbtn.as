package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol77")]
   public dynamic class pvp_frame_optionsbtn extends UIMovieClip
   {
      
      public function pvp_frame_optionsbtn()
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


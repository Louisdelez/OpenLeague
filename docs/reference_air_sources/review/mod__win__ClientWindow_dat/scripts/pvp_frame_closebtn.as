package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol283")]
   public dynamic class pvp_frame_closebtn extends UIMovieClip
   {
      
      public function pvp_frame_closebtn()
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


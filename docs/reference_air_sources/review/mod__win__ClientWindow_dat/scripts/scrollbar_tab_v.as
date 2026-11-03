package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol480")]
   public dynamic class scrollbar_tab_v extends UIMovieClip
   {
      
      public function scrollbar_tab_v()
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


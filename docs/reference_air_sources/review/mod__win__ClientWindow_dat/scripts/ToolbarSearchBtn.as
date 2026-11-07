package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol242")]
   public dynamic class ToolbarSearchBtn extends UIMovieClip
   {
      
      public function ToolbarSearchBtn()
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


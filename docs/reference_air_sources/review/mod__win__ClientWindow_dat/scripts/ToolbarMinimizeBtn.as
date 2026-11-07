package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol385")]
   public dynamic class ToolbarMinimizeBtn extends UIMovieClip
   {
      
      public function ToolbarMinimizeBtn()
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


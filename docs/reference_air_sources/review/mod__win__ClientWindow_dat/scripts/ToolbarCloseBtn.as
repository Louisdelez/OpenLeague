package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol40")]
   public dynamic class ToolbarCloseBtn extends UIMovieClip
   {
      
      public function ToolbarCloseBtn()
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


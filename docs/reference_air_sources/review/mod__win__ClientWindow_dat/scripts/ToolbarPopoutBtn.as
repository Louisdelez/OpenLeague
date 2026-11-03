package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol97")]
   public dynamic class ToolbarPopoutBtn extends UIMovieClip
   {
      
      public function ToolbarPopoutBtn()
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


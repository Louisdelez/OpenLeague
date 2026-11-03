package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol444")]
   public dynamic class ToolbarSettingsBtn extends UIMovieClip
   {
      
      public function ToolbarSettingsBtn()
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


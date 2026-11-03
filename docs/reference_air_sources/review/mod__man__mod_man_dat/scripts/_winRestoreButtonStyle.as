package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _winRestoreButtonStyle
   {
      
      private static var _embed_css_win_restore_over_png_1886247308:Class = _winRestoreButtonStyle__embed_css_win_restore_over_png_1886247308;
      
      private static var _embed_css_win_restore_up_png_153787142:Class = _winRestoreButtonStyle__embed_css_win_restore_up_png_153787142;
      
      private static var _embed_css_win_restore_down_png_411031368:Class = _winRestoreButtonStyle__embed_css_win_restore_down_png_411031368;
      
      public function _winRestoreButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".winRestoreButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".winRestoreButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = _embed_css_win_restore_up_png_153787142;
               this.downSkin = _embed_css_win_restore_down_png_411031368;
               this.overSkin = _embed_css_win_restore_over_png_1886247308;
            };
         }
      }
   }
}

